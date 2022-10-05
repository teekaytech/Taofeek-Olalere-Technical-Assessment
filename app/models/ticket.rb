class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum :status, %i[active inactive], prefix: true, scopes: true, default: :active
end
