# frozen_string_literal: true

require 'rails_helper'

RSpec.describe CreatePolicyService do
  describe '#execute' do
    subject(:service) { described_class.execute(policy_params) }

    context 'when missing attributes from' do
      let(:policy_params) {
        new_policy_attr.merge({
          insured_person: new_insured_person_attr,
          vehicle: new_vehicle_attr
        })
      }
      let(:new_policy_attr) do
        {
          effective_from: Date.today,
          effective_until: 1.year.from_now
        }
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

      context 'insured_person' do
        before do
          new_insured_person_attr[:name] = nil
        end

        it { is_expected.to eq nil }
      end

      context 'vehicle' do
        before do
          new_vehicle_attr[:brand] = nil
        end

        it { is_expected.to eq nil }
      end

      context 'policy' do
        before do
          new_policy_attr[:effective_from] = nil
        end

        it 'returns nil' do
          expect(subject).to eq nil
        end
      end
    end

    context 'when a policy already exists' do
      before do
        Policy.create!(
          effective_from: Date.today,
          effective_until: 1.year.from_now,
          insured_person_attributes: old_insured_person,
          vehicle_attributes: old_vehicle
        )
      end
      let(:old_insured_person) do
        {
          name: 'Old Name',
          document: '000.000.000-00',
          email: 'another_email@email.com'
        }
      end
      let(:old_vehicle) do
        {
          brand: "Old brand",
          vehicle_model: "Palio 1.0",
          year: "1998",
          license_plate: "AAA-1111"
        }
      end

      let(:policy_params) do
        new_policy_attr.merge(
          {
            insured_person: new_insured_person_attr,
            vehicle: new_vehicle_attr
          }
        )
      end
      let(:new_policy_attr) do
        {
          effective_from: Date.today,
          effective_until: 1.year.from_now
        }
      end

      context 'and insured person already exists' do
        let(:new_insured_person_attr) { old_insured_person }

        context 'and different vehicle attributes are sent' do
          let(:new_vehicle_attr) do
            {
              brand: "New brand",
              vehicle_model: "Gol 1.6",
              year: "2022",
              license_plate: "ABC-5678"
            }
          end

          it 'returns a policy' do
            expect(subject.class).to eq Policy
          end

          it 'creates policy with vehicle attributes' do
            expect { subject }.to change { Policy.count }.by(1)
            expect(Policy.last.vehicle.brand).to eq(new_vehicle_attr[:brand])
          end

          it 'creates vehicle' do
            expect { subject }.to change { Vehicle.count }.by(1)
            expect(Vehicle.last.brand).to eq(new_vehicle_attr[:brand])
          end

          it 'does NOT creates insured_person' do
            expect { subject }.not_to change { InsuredPerson.count }
          end
        end

        context 'when vehicle with same attributes as a already created vechicle are sent' do
          let(:new_vehicle_attr) { old_vehicle }

          it 'returns nil' do
            expect(subject).to eq nil
          end

          it 'does NOT creates policy' do
            expect { subject }.not_to change { Policy.count }
          end

          it 'does NOT creates vehicle' do
            expect { subject }.not_to change { Vehicle.count }
          end

          it 'does NOT creates insured_person' do
            expect { subject }.not_to change { InsuredPerson.count }
          end
        end
      end

      context 'when insured person does NOT exist' do
        let(:new_insured_person_attr) do
          {
            name: 'Maria Silva',
            document: '123.456.789-00',
            email: 'maria@email.com'
          }
        end

        context 'and different vehicle attributes are sent' do
          let(:new_vehicle_attr) do
            {
              brand: "New brand",
              vehicle_model: "Gol 1.6",
              year: "2022",
              license_plate: "ABC-5678"
            }
          end

          it 'returns a Policy' do
            expect(subject.class).to eq Policy
          end

          it 'creates policy' do
            expect { subject }.to change { Policy.count }.by(1)
          end

          it 'creates vehicle' do
            expect { subject }.to change { Vehicle.count }.by(1)
          end

          it 'creates insured_person' do
            expect { subject }.to change { InsuredPerson.count }.by(1)
          end
        end

        context 'when vehicle with same attributes as a already created vechicle are sent' do
          let(:new_vehicle_attr) { old_vehicle }

          it 'returns nil' do
            expect(subject).to eq nil
          end

          it 'does NOT creates policy' do
            expect { subject }.not_to change { Policy.count }
          end

          it 'does NOT creates vehicle' do
            expect { subject }.not_to change { Vehicle.count }
          end

          it 'does NOT creates insured_person' do
            expect { subject }.not_to change { InsuredPerson.count }
          end
        end
      end
    end

    context 'with new attributes for all related objects' do
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
      let(:policy_params) do
        new_policy_attr.merge(
          {
            insured_person: new_insured_person_attr,
            vehicle: new_vehicle_attr
          }
        )
      end
      let(:new_policy_attr) do
        {
          effective_from: Date.today,
          effective_until: 1.year.from_now
        }
      end
      let(:products) do
        [ OpenStruct.new({ id: 'prod_Q11TuaYy85lsvV' })]
      end
      let(:price) do
        OpenStruct.new({
          id: 'price_1PBOydCT1rSKEpFZLjCaHY7u',
          object: 'price',
          active: true,
          currency: 'brl',
          unit_amount: 1000,
          unit_amount_decimal: '1000'
        })
      end
      let(:checkout) do
        OpenStruct.new({
          id: 'cs_test_a1vImutXYDdd7CmHDJiwdh7PEq4maE8QPBnLQNtFKCU96TDEVhl9h80Ruo',
          object: 'checkout.session',
          amount_subtotal: 1000,
          amount_total: 1000,
          currency: 'brl',
          mode: 'payment',
          payment_method_types: [ 'card' ],
          payment_status: 'unpaid',
          success_url: 'https://www.youtube.com/',
          url: 'https://checkout.stripe.com/c/pay/generic_link'
        })
      end

      before do
        allow(Stripe::Product).to receive(:search).and_return(products)
        allow(Stripe::Price).to receive(:create).and_return(price)
        allow(Stripe::Checkout::Session).to receive(:create).and_return(checkout)
      end

      it ' creates a policy' do
        expect { subject }.to change { Policy.count }.by(1)
        policy = Policy.last

        expect(policy.effective_from).to eq(new_policy_attr[:effective_from])
        expect(policy.effective_until).to eq(new_policy_attr[:effective_until].to_date)
        expect(policy.status).to eq('draft')
        expect(policy.vehicle.id).to eq(Vehicle.last.id)
        expect(policy.insured_person.id).to eq(InsuredPerson.last.id)
        expect(policy.payment.id).to eq(Payment.last.id)
      end

      it 'creates a vehicle' do
        expect { subject }.to change { Vehicle.count }.by(1)

        vehicle = Vehicle.last

        expect(vehicle.brand).to eq(vehicle[:brand])
        expect(vehicle.vehicle_model).to eq(vehicle[:vehicle_model])
        expect(vehicle.year).to eq(vehicle[:year])
        expect(vehicle.license_plate).to eq(vehicle[:license_plate])
      end

      it 'creates an insured person' do
        expect { subject }.to change { InsuredPerson.count }.by(1)

        insured_person = InsuredPerson.last

        expect(insured_person.name).to eq(insured_person[:name])
        expect(insured_person.document).to eq(insured_person[:document])
        expect(insured_person.email).to eq(insured_person[:email])
      end

      it 'creates a payment' do
        expect { subject }.to change { Payment.count }.by(1)

        payment = Payment.last

        expect(payment.status).to eq('pending')
        expect(payment.external_id).to eq(checkout.id)
        expect(payment.link).to eq(checkout.url)
        expect(payment.price).to eq(checkout.amount_total)
      end

      context 'when Stripe return invalid objects' do
        before do
          allow(Stripe::Product).to receive(:search).and_return([])
          allow(Stripe::Price).to receive(:create).and_return(nil)
          allow(Stripe::Checkout::Session).to receive(:create).and_return(nil)
        end

        it 'returns nil' do
          expect(subject).to eq nil
          expect(Policy.count).to eq 0
          expect(InsuredPerson.count).to eq 0
          expect(Vehicle.count).to eq 0
          expect(Payment.count).to eq 0
        end
      end
    end
  end
end
