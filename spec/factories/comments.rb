FactoryBot.define do
  factory :comment do
    body { 'Body' }
    commentable { create(:question) }
    user
  end

  factory :invalid_comment, class: 'Comment' do
    body { nil }
    commentable { nil }
    user { nil }
  end
end
