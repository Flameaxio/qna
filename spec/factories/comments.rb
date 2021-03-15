FactoryBot.define do
  factory :comment do
    body { 'Body' }
    question
    user
  end

  factory :invalid_comment, class: 'Comment' do
    body { nil }
    question { nil }
    user { nil }
  end
end
