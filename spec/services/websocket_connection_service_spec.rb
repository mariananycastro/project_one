require 'rails_helper'

RSpec.describe WebsocketConnectionService do
  describe '#broadcast' do
    let(:url) { 'http://example.com/websocket' }
    let(:message) { { data: 'test message' } }
    subject(:service) { described_class.new(url, message) }
    let(:jwt_token) { 'mocked_jwt_token' }

    before do
      allow(service).to receive(:token).and_return(jwt_token)
      allow(Net::HTTP).to receive(:post)
    end

    it 'sends a POST request with the correct parameters' do
      service.broadcast

      expect(Net::HTTP).to have_received(:post).with(
        URI(url),
        message.to_json,
        'Content-Type' => 'application/json',
        'Authorization' => "Bearer #{jwt_token}"
      )
    end
  end
end
