require 'rails_helper'

RSpec.describe UpdatePaymentService do
  describe '#execute' do
    subject(:service) { described_class.execute(params) }
    let(:policy) do
      Policy.create!(
        effective_from: Date.today,
        effective_until: 1.year.from_now,
        insured_person_attributes: new_insured_person_attr,
        vehicle_attributes: new_vehicle_attr,
      )
    end
    let(:new_insured_person_attr) do
      {
        name: 'Maria Silva',
        document: '123.456.789-00',
        email: 'maria@email.com'
      }
    end
    let(:new_vehicle_attr) do
      {
        brand: "New brand",
        vehicle_model: "Gol 1.6",
        year: "2022",
        license_plate: "ABC-5678"
      }
    end
    let(:payment) do
      Payment.create(
        external_id: 'cs_test_a1CprekT1s',
        link: 'link_url',
        price: 1000,
        policy_id: policy.id
      )
    end
    let(:params) do
      {
        id: id,
        object:'checkout.session',
        payment_status: payment_status,
        status: status,
        success_url:'http://localhost:3000/success_payment',
        amount_total: payment.price,
        url: payment.link
      }
    end

    before do
      policy
      payment
    end

    context 'when payment was paid' do
      let(:payment_status) { 'paid' }
      let(:status) { 'complete' }

      context 'when find payment' do
        let(:id) { payment.external_id }

        it 'update payment and policy' do
          expect { subject }
            .to change { payment.reload.status }.from('pending').to('paid')
            .and change { payment.policy.reload.status }.from('draft').to('active')
        end

        it 'calls WebsocketConnectionService' do
          messagem = {
            email: policy.insured_person.email,
            license_plate: policy.vehicle.license_plate,
            payment_status: 'paid',
            policy_status: 'active'
          }

          expect(WebsocketConnectionService)
            .to receive(:broadcast)
            .with(ENV['SINATRA_BROADCAST_URL'], messagem)

          subject
        end
      end

      context 'when does NOT find payment' do
        let(:id) { 'another_id' }

        it 'raise InvalidPaymentUpdateError' do
          expect(WebsocketConnectionService).not_to receive(:broadcast)

          expect { subject }
            .to raise_error(
              UpdatePaymentService::InvalidPaymentUpdateError,
              "Error to update payment #{ id }")
        end
      end
    end

    context 'payment expired' do
      let(:payment_status) { 'unpaid' }
      let(:status) { 'expired' }

      context 'when find payment' do
        let(:id) { payment.external_id }

        context 'and finds policy' do
          it 'update payment and policy' do
            expect { subject }
              .to change { payment.reload.status }.from('pending').to('expired')
              .and change { payment.policy.reload.status }.from('draft').to('canceled')
          end
        end

        it 'calls WebsocketConnectionService' do
          messagem = {
            email: policy.insured_person.email,
            license_plate: policy.vehicle.license_plate,
            payment_status: 'expired',
            policy_status: 'canceled'
          }

          expect(WebsocketConnectionService).to receive(:broadcast).with(ENV['SINATRA_BROADCAST_URL'], messagem)

          subject
        end
      end

      context 'when does NOT find payment' do
        let(:id) { 'another_id' }

        it 'raise InvalidPaymentUpdateError' do
          expect(WebsocketConnectionService).not_to receive(:broadcast)

          expect{ subject }
            .to raise_error(
              UpdatePaymentService::InvalidPaymentUpdateError,
              "Error to update payment #{ id }")
        end
      end
    end
  end
end
