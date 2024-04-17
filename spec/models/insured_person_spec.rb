# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InsuredPerson, type: :model do
  describe 'Validations' do
    subject(:new_insured_person) do
      described_class.create(name: name, document: document)
    end

    context 'when has name and document' do
      let(:name) { 'bolinha silva' }
      let(:document) { '123456789' }

      it 'creates a insured person' do
        expect{ subject }.to change { InsuredPerson.count }.by 1
      end
    end

    context 'missing params' do
      let(:name) { '' }
      let(:document) { '' }

      it 'does NOT create a insured person' do
        expect{ subject }.not_to change { InsuredPerson.count }
      end

      it 'returns missing attributes messages' do
        expect(subject.errors.full_messages).to eq(
          ["Name can't be blank", "Document can't be blank"]
        )
      end
    end

    context 'when insured_person with document that already exists' do
      let(:document) { '123456789' }
      let(:name) { 'Another name' }

      before do
        InsuredPerson.create!(name: 'Bolinha Silva', document: document)
      end

      it 'does NOT create a insured person' do
        expect{ subject }.not_to change { InsuredPerson.count }
      end

      it 'returns missing attributes messages' do
        expect(subject.errors.full_messages).to eq(
          ["Document has already been taken"]
        )
      end
    end
  end
end
