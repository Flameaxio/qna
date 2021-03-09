FactoryBot.define do
  factory :question do
    title { "Title" }
    body { "Body" }
    user_id { create(:user).id }
  end
  factory :invalid_question, class: 'Question' do
    title { 'Title' }
    user_id { create(:user).id }
  end
end
