# frozen_string_literal: true

require 'rails_helper'

RSpec.describe InsuredPerson, type: :model do
  describe 'Validations' do
    subject(:new_insured_person) do
      described_class.create(name: name, document: document, email: email)
    end

    context 'when has name and document' do
      let(:name) { 'bolinha silva' }
      let(:document) { '123456789' }
      let(:email) { 'bolinha@email.com' }

      it 'creates a insured person' do
        expect{ subject }.to change { InsuredPerson.count }.by 1
      end
    end

    context 'missing params' do
      let(:name) { '' }
      let(:document) { '' }
      let(:email) { '' }

      it 'does NOT create a insured person' do
        expect{ subject }.not_to change { InsuredPerson.count }
      end

      it 'returns missing attributes messages' do
        expect(subject.errors.full_messages).to eq(
          [
            "Name can't be blank",
            "Document can't be blank",
            "Email can't be blank"
          ]
        )
      end
    end

    context 'when insured_person with document that already exists' do
      let(:document) { '123456789' }
      let(:name) { 'Another name' }
      let(:email) { 'another_email@email.com' }

      before do
        InsuredPerson.create!(
          name: 'Bolinha Silva',
          document: document,
          email: 'bolinha@email.com')
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

    context 'when insured_person with email that already exists' do
      let(:document) { '123456789' }
      let(:name) { 'Another name' }
      let(:email) { 'bolinha@email.com' }

      before do
        InsuredPerson.create!(
          name: 'Bolinha Silva',
          document: '987654321',
          email: email)
      end

      it 'does NOT create a insured person' do
        expect{ subject }.not_to change { InsuredPerson.count }
      end

      it 'returns missing attributes messages' do
        expect(subject.errors.full_messages).to eq(
          ["Email has already been taken"]
        )
      end
    end
  end
end
