json.extract! ticket, :id, :user_id, :event_id, :status, :created_at
json.user ticket.user
json.event ticket.event
json.url api_v1_ticket_url(ticket, format: :json)
