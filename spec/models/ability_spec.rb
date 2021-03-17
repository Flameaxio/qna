require 'rails_helper'

RSpec.describe Ability, type: :model do
  subject(:ability) { Ability.new(user) }

  describe 'for guest' do
    let(:user) { nil }

    it { should be_able_to :read, Question }
    it { should be_able_to :read, Answer }
    it { should be_able_to :read, Comment }
    it { should be_able_to :read, Attachment }

    it { should_not be_able_to :manage, :all }
  end

  describe 'for admin' do
    let(:user) { create(:user, admin: true) }

    it { should be_able_to :manage, :all }
  end

  describe 'for user' do
    let!(:user) { create(:user) }
    let!(:another_user) { create(:user) }

    it { should_not be_able_to :manage, :all }
    it { should be_able_to :read, :all }

    it { should be_able_to :create, Question }
    it { should be_able_to :create, Answer }
    it { should be_able_to :comment_answer, Comment }
    it { should be_able_to :comment_question, Comment }
    it { should be_able_to :create, Attachment }

    it { should be_able_to :update, create(:question, user_id: user.id), user: user }
    it { should be_able_to :update, create(:answer, user_id: user.id), user: user }
    it { should_not be_able_to :update, create(:question, user_id: another_user.id), user: user }
    it { should_not be_able_to :update, create(:answer, user_id: another_user.id), user: user }

    it { should be_able_to :destroy, create(:question, user_id: user.id), user: user }
    it { should be_able_to :destroy, create(:answer, user_id: user.id), user: user }
    it { should_not be_able_to :destroy, create(:question, user_id: another_user.id), user: user }
    it { should_not be_able_to :destroy, create(:answer, user_id: another_user.id), user: user }

    let!(:my_question) { create(:question, user_id: user.id) }
    let!(:other_question) { create(:question, user_id: another_user.id) }
    it { should be_able_to :set_best, create(:answer, question: my_question, user_id: user.id), user: user }
    it { should_not be_able_to :set_best, create(:answer, question: other_question, user_id: user.id), user: user }
  end
end
