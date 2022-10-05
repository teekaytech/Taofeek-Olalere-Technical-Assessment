require 'rails_helper'

RSpec.describe User, type: :model do
  it { should have_many(:events).dependent(:destroy) }
  it { should have_many(:tickets).dependent(:destroy) }

  it { should validate_presence_of(:email) }
  it { should validate_presence_of(:password) }
  it { should validate_uniqueness_of(:email).ignoring_case_sensitivity }
  it { should validate_length_of(:password).is_at_least(6) }
end
