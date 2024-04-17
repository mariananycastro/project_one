# frozen_string_literal: true

require 'rails_helper'

RSpec.describe Vehicle, type: :model do
  describe 'Validations' do
    subject(:new_vehicle) do
      described_class.create(
        brand: brand,
        vehicle_model: vehicle_model,
        year: year,
        license_plate: license_plate
      )
    end

    context 'when has all attributes' do
      let(:brand) { 'New brand' }
      let(:vehicle_model) { 'Gol 1.6' }
      let(:year) { '2022' }
      let(:license_plate) { 'ABC-5678' }

      it 'creates a vehicle' do
        expect{ subject }.to change { Vehicle.count }.by 1
      end
    end

    context 'missing params' do
      let(:brand) { '' }
      let(:vehicle_model) { '' }
      let(:year) { '' }
      let(:license_plate) { '' }

      it 'does NOT create a vehicle' do
        expect{ subject }.not_to change { Vehicle.count }
      end

      it 'returns missing attributes messages' do
        expect(subject.errors.full_messages).to eq(
          [
            "Brand can't be blank",
            "Vehicle model can't be blank",
            "Year can't be blank",
            "License plate can't be blank"
          ]
        )
      end
    end

    context 'when vehicle with license plate that already exists' do
      let(:brand) { 'New brand' }
      let(:vehicle_model) { 'Gol 1.6' }
      let(:year) { '2022' }
      let(:license_plate) { 'ABC-5678' }

      before do
        Vehicle.create!(
          brand: 'Another brand',
          vehicle_model: 'Another model',
          year: '1990',
          license_plate: license_plate
        )
      end

      it 'does NOT create a vehicle' do
        expect{ subject }.not_to change { Vehicle.count }
      end

      it 'returns missing attributes messages' do
        expect(subject.errors.full_messages).to eq(
          ["License plate has already been taken"]
        )
      end
    end
  end
end
