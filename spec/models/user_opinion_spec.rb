require 'rails_helper'

RSpec.describe UserOpinion, type: :model do
  it { should belong_to :user }
  it { should belong_to :answer }
  it { should validate_inclusion_of(:opinion).in_array([-1, 0, 1]) }
end
