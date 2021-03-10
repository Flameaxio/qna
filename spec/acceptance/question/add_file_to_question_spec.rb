require 'acceptance/acceptance_helper'

feature 'Add file to question', '
  In order to convey my problem better
  As an author of the question
  I should be able to add attachments to the file
' do
  given!(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }

  scenario 'User adds file to the question' do
    sign_in(user)
    visit question_path(question)

    within '.question' do
      click_on 'Edit'
      click_on 'Add file'
      attach_file 'File', "#{Rails.root}/spec/spec_helper.rb"
      click_on 'Save'

      expect(page).to have_link 'spec_helper.rb'
    end
  end
end