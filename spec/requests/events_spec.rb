require 'rails_helper'

RSpec.describe 'Api::V1::Events', type: :request do
  describe 'GET /api/v1/events' do
    let!(:user) { create(:user) }
    let!(:events) { create_list(:event, 5, user: user) }
    let!(:events2) { create_list(:event, 5, user: user, status: :inactive) }
    let!(:events3) { create_list(:event, 5, user: user, category: :paid) }

    context 'when the request is valid' do
      before(:each) do
        login_user(user)
      end

      it 'returns all events' do
        get api_v1_events_path, headers: auth_headers

        expect(json).not_to be_empty
        expect(json.size).to eq(15)
        expect(response).to have_http_status(200)
      end

      it 'returns all paid events' do
        get api_v1_events_path, headers: auth_headers, params: { category: 'paid' }
        expect(json.size).to be > 5
      end

      it 'returns all inactive events' do
        get api_v1_events_path, headers: auth_headers, params: { status: 'inactive' }
        expect(json.size).to be > 5
      end
    end

    context 'when request is invalid' do
      it 'returns error message' do
        get api_v1_events_path

        expect(json['error']).to eq('You need to sign in or sign up before continuing.')
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end

  describe 'GET /api/v1/event/:id' do
    let!(:user) { create(:user) }
    let!(:event) { create(:event, user: user) }
    before do
      login_user(user)
    end

    it 'returns an event' do
      get api_v1_event_path(id: event.id), headers: auth_headers

      expect(json['id']).to eq(event.id)
      expect(json['url']).to_not be_empty
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'GET  /api/v1/users/:id/events' do
    let!(:user) { create(:user) }
    let!(:user2) { create(:user) }
    let!(:event) { create_list(:event, 2, user: user) }
    let!(:event2) { create_list(:event, 2, user: user2) }
    before(:each) do
      login_user(user2)
    end

    it 'returns user events' do
      get "/api/v1/users/#{user.id}/events", headers: auth_headers

      expect(json.size).to eq(2)
      expect(response).to have_http_status(:ok)
    end

    it 'returns other user events' do
      get "/api/v1/users/#{user2.id}/events", headers: auth_headers

      expect(json.size).to eq(2)
      expect(response).to have_http_status(:ok)
    end
  end

  describe 'POST /api/v1/events' do
    let!(:user) { create(:user) }
    let!(:event) { build(:event) }
    let(:valid_attributes) do
      {
        event: {
          title: event.title,
          description: event.description,
          category: event.category,
          status: event.status,
          start_date: event.start_date,
          end_date: event.end_date,
          user_id: user.id
        }
      }
    end

    let(:invalid_attributes) do
      {
        event: {
          start_date: 1.day.ago,
          end_date: 2.days.ago
        }
      }
    end

    before do
      login_user(user)
    end

    context 'when the request is valid' do
      it 'creates an event' do
        expect(Event.count).to eq(0)

        post api_v1_events_path, headers: auth_headers, params: valid_attributes

        expect(Event.count).to eq(1)
        expect(response).to have_http_status(:created)
      end
    end

    context 'when the request is invalid' do
      it 'does not create an event' do
        expect(Event.count).to eq(0)

        post api_v1_events_path, headers: auth_headers, params: invalid_attributes

        expect(Event.count).to eq(0)
        expect(json['start_date']).to include('must be before end date')
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PATCH /api/v1/event/:id' do
    let!(:user) { create(:user) }
    let!(:event) { create(:event, user: user) }
    before do
      login_user(user)
    end

    it 'updates an event' do
      patch api_v1_event_path(id: event.id), headers: auth_headers, params: { event: { title: 'New Title' } }

      expect(json['title']).to eq('New Title')
      expect(response).to have_http_status(:ok)
    end

    it 'does not update an event with nil title' do
      patch api_v1_event_path(id: event.id), headers: auth_headers, params: { event: { title: '' } }

      expect(json['title']).to include("can't be blank")
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end

  describe 'DELETE /api/v1/event/:id' do
    let!(:user) { create(:user) }
    let!(:event) { create(:event, user: user) }
    before do
      login_user(user)
    end

    it 'deletes an event' do
      expect(Event.count).to eq(1)

      delete api_v1_event_path(id: event.id), headers: auth_headers

      expect(Event.count).to eq(0)
      expect(response).to have_http_status(:no_content)
    end
  end
end
