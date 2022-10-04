FactoryBot.define do
  factory :ticket do
    user
    event
    status { Ticket.statuses.keys.sample }
  end
end
