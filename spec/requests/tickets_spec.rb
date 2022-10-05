require 'rails_helper'

RSpec.describe 'Api::V1::Tickets', type: :request do
  describe 'POST /api/v1/tickets' do
    let!(:user) { create(:user) }
    let!(:event) { create(:event, user: user) }
    before(:each) do
      login_user(user)
    end

    context 'when the request is valid' do
      it 'creates a ticket' do
        post api_v1_tickets_path, headers: auth_headers, params: { ticket: { event_id: event.id } }

        expect(json['user_id']).to eq(user.id)
        expect(json['event_id']).to eq(event.id)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      it 'returns error message' do
        post api_v1_tickets_path, headers: auth_headers, params: { ticket: { event_id: '' } }

        expect(json['event']).to include('must exist')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'GET /api/v1/tickets/:id' do
    let!(:user) { create(:user) }
    let!(:event) { create(:event, user: user) }
    let!(:ticket) { create(:ticket, user: user, event: event) }
    before do
      login_user(user)
    end

    it 'deletes a ticket' do
      get api_v1_ticket_path(ticket), headers: auth_headers

      expect(json['id']).to eq(ticket.id)
      expect(json['user']['id']).to eq(user.id)
      expect(json['event']['id']).to eq(event.id)
      expect(response).to have_http_status(:ok)
    end
  end
end
