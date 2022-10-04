json.extract! event, :id, :title, :category, :status, :start_date, :end_date, :created_at
json.user_id event.user_id
json.url api_v1_event_url(event, format: :json)
