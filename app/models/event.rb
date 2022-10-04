class Event < ApplicationRecord
  belongs_to :user
  has_many :tickets, dependent: :destroy

  validates :title, presence: true, length: { minimum: 5, maximum: 50 }
  validates :description, presence: true, length: { minimum: 5, maximum: 500 }
  validates :status, :category, :start_date, :end_date, presence: true
  validate :start_and_end_dates

  enum :status, [ :active, :inactive ], prefix: true, scopes: false, default: :active
  enum :category, [ :free, :paid ], prefix: true, scopes: false, default: :free

  scope :with_status, -> (status) { status == 'active' ? active : inactive if status.present? }
  scope :inactive, -> { where(status: :inactive) }
  scope :active, -> { where(status: :active) }

  scope :with_category, -> (category) { category == 'free' ? free : paid if category.present? }
  scope :free, -> { where(category: :free) }
  scope :paid, -> { where(category: :paid) }

  def start_and_end_dates
    if start_date > end_date
      errors.add(:start_date, 'must be before end date')
      errors.add(:end_date, 'must be after start date')
    elsif start_date < Date.today
      errors.add(:start_date, 'must be in the future')
    elsif end_date < Date.today
      errors.add(:end_date, 'must be in the future')
    end
  end
end
