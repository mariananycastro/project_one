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
          document: '123.456.789-00'
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
          document: '000.000.000-00'
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
            document: '123.456.789-00'
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
  end
end
