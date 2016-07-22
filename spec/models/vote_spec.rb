require 'rails_helper'

RSpec.describe Vote, type: :model do
  it { should belong_to(:user) }
  it { should belong_to(:votable) }
  it { should validate_presence_of(:user_id) }
  it { should validate_inclusion_of(:rate_point).in?(-1..1) }
end
