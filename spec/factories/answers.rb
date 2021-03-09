FactoryBot.define do
  factory :answer do
    body { 'Body' }
    question
  end

  factory :invalid_answer, class: 'Answer' do
    body { nil }
    question
  end
end
