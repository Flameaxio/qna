FactoryBot.define do
  factory :question do
    title { "Title" }
    body { "Body" }
  end
  factory :invalid_question, class: 'Question' do
    title { 'Title' }
  end
end
