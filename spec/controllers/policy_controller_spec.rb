# frozen_string_literal: true

require 'rails_helper'

RSpec.describe 'Policy', type: :request do
  context '#show' do
    subject(:request) { get policy_path(id) }

    context 'when find policy' do
      let(:policy) do
        Policy.create!(
          effective_from: Date.today,
          effective_until: 1.year.from_now,
          insured_person_attributes: {
            name: 'Maria Silva',
            document: '123.456.789-00',
            email: 'maria@email.com'
          },
          vehicle_attributes: {
            brand: "New brand",
            vehicle_model: "Gol 1.6",
            year: "2022",
            license_plate: 'ABC-1234'
          }
        )
      end
      let(:id) { policy.id }

      it 'return success' do
        request

        expect(response).to have_http_status(200)
        expect(JSON.parse(response.body)['id']).to eq policy.id
      end
    end

    context 'when does NOT find policy' do
      let(:id) { 1 }

      it 'return 404' do
        request

        expect(response).to have_http_status(404)
        expect(response.body).to eq ''
      end
    end
  end

  context '#index' do
    subject(:request) { get policies_path }

    let(:policy) do
      Policy.create!(
        effective_from: Date.today,
        effective_until: 1.year.from_now,
        insured_person_attributes: {
          name: 'Maria Silva',
          email: 'maria@email.com',
          document: '123.456.789-00'
        },
        vehicle_attributes: {
          brand: "New brand",
          vehicle_model: "Gol 1.6",
          year: "2022",
          license_plate: 'ABC-1234'
        }
      )
    end
  
    context 'there are policies created' do
      it 'list policies' do
        policy
        request

        response_body = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(response_body.first['id']).to eq policy.id
      end
    end

    context 'there are policies created' do
      it 'list policies' do
        request

        response_body = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(response_body).to eq []
      end
    end
  end

  context '#insured_person_policies_by_email' do
    subject(:request) { get "/insured_person/#{email}" }

    let(:policy) do
      Policy.create!(
        effective_from: Date.today,
        effective_until: 1.year.from_now,
        insured_person_attributes: {
          name: 'Maria Silva',
          email: email,
          document: '123.456.789-00'
        },
        vehicle_attributes: {
          brand: "New brand",
          vehicle_model: "Gol 1.6",
          year: "2022",
          license_plate: 'ABC-1234'
        }
      )
    end

    context 'when insured person has policy' do
      let(:email) { 'maria@email.com' }

      before { policy }

      it 'return policies from given email' do
        request
        response_body = JSON.parse(response.body)
        
        expect(response).to have_http_status(200)
        expect(response_body.first['id']).to eq policy.id
      end
    end

    context 'when insured person does NOT have policy' do
      let(:email) { 'another@email.com' }

      it 'return policies from given email' do
        request
        response_body = JSON.parse(response.body)

        expect(response).to have_http_status(200)
        expect(response_body).to eq []
      end
    end
  end  
end
