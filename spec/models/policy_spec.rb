# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Policy, type: :model do
  describe 'Validations' do
    let(:insured_person_attributes) do
      {
        name: 'Maria Silva',
        document: '123.456.789-00'
      }
    end
    let(:license_plate) { 'ABC-5678' }
    let(:vehicle_attributes) do
      {
        brand: "New brand",
        vehicle_model: "Gol 1.6",
        year: "2022",
        license_plate: license_plate
      }
    end
    subject(:new_policy) do
      described_class.create(
        effective_from: effective_from,
        effective_until: effective_until,
        insured_person_attributes: insured_person_attributes,
        vehicle_attributes: vehicle_attributes
       )
    end

    context 'when has all attributes' do
      let(:effective_from) { Date.today }
      let(:effective_until) { 1.year.from_now }

      it 'creates a policy' do
        expect{ subject }.to change { Policy.count }.by 1
      end
    end

    context 'missing params' do
      let(:effective_from) { nil }
      let(:effective_until) { nil }

      it 'does NOT create a policy' do
        expect{ subject }.not_to change { Policy.count }
      end

      it 'returns missing attributes messages' do
        expect(subject.errors.full_messages).to eq(
          ["Effective from can't be blank", "Effective until can't be blank"]
        )
      end
    end
  end

  describe 'associations' do
    context 'when insured person does is NOT present' do
      let(:vehicle_attributes) do
        {
          brand: "New brand",
          vehicle_model: "Gol 1.6",
          year: "2022",
          license_plate: 'ABC-5678'
        }
      end
      subject(:new_policy) do
        described_class.create(
          effective_from: Date.today,
          effective_until: 1.year.from_now,
          vehicle_attributes: vehicle_attributes
        )
      end

      it 'does NOT create a policy' do
        expect{ subject }.not_to change { Policy.count }
      end

      it 'returns missing attributes messages' do
        expect(subject.errors.full_messages).to eq(
          ['Insured person must exist', "Insured person can't be blank"]
        )
      end
    end

    context 'when vehicle is NOT valid' do
      let(:insured_person_attributes) do
        {
          name: 'Maria Silva',
          document: '123.456.789-00'
        }
      end
      subject(:new_policy) do
        described_class.create(
          effective_from: Date.today,
          effective_until: 1.year.from_now,
          insured_person_attributes: insured_person_attributes
        )
      end

      it 'does NOT create a policy' do
        expect{ subject }.not_to change { Policy.count }
      end

      it 'returns missing attributes messages' do
        expect(subject.errors.full_messages).to eq(
          ['Vehicle must exist', "Vehicle can't be blank"]
        )
      end
    end

    context 'when a policy for the vehicle already exists' do
      subject(:new_policy) do
        described_class.create(
          effective_from: Date.today,
          effective_until: 1.year.from_now,
          insured_person_attributes: insured_person_attributes,
          vehicle_attributes: vehicle_attributes
         )
      end
      let(:insured_person_attributes) do
        {
          name: 'Maria Silva',
          document: '123.456.789-00'
        }
      end
      let(:vehicle_attributes) do
        {
          brand: "New brand",
          vehicle_model: "Gol 1.6",
          year: "2022",
          license_plate: license_plate
        }
      end
      let(:license_plate) { 'ABC-5678' }

      let(:another_vehicle) do
        Vehicle.create!(
          brand: 'Another brand',
          vehicle_model: 'Another model',
          year: '1990',
          license_plate: license_plate
        )
      end
      let(:another_insured_person) do
        InsuredPerson.create!(
          name: 'Another Person',
          document: '987.654.321-00'
        )
      end

      before do
        Policy.create!(
          effective_from: Date.today,
          effective_until: 1.year.from_now,
          insured_person_id: another_insured_person.id,
          vehicle_id: another_vehicle.id
        )
      end

      it 'does NOT create a policy' do
        expect{ subject }.not_to change { Policy.count }
      end

      it 'returns missing attributes messages' do
        expect(subject.errors.full_messages).to eq(
          [ 
            "Vehicle license plate has already been taken",
            "Vehicle already has policy"
          ]
        )
      end
    end
  end
end
