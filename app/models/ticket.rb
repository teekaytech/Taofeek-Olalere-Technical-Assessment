class Ticket < ApplicationRecord
  belongs_to :user
  belongs_to :event

  enum :status, [ :active, :inactive], prefix: true, scopes: true, default: :active
end
