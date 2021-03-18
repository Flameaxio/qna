FactoryBot.define do
  factory :attachment do
    file { Rack::Test::UploadedFile.new(Rails.root.join('spec/support/logo_image.jpg'), 'image/jpeg') }
    attachable { create(:question) }
  end
end
