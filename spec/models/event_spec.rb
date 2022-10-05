require 'rails_helper'

RSpec.describe Event, type: :model do
  it { should belong_to(:user) }
  it { should have_many(:tickets).dependent(:destroy) }

  it { should validate_presence_of(:title) }
  it { should validate_length_of(:title).is_at_least(5).is_at_most(50) }

  it { should validate_presence_of(:description) }
  it { should validate_length_of(:description).is_at_least(5).is_at_most(500) }

  it { should validate_presence_of(:start_date) }
  it { should validate_presence_of(:end_date) }
end
