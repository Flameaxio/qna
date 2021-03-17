require 'acceptance/acceptance_helper'

feature 'Create question', '
  In order to get an answer from the community
  As an authenticated user
  I want to be able to ask questions
' do

  given(:user) { create(:user) }

  scenario 'Authenticated user creates the question' do
    sign_in(user)

    visit questions_path
    click_on 'Ask a question'
    fill_in 'Title', with: 'Test question'
    fill_in 'Body', with: 'text text'
    click_on 'Ask!'

    expect(page).to have_content 'Question was successfully created.'
  end

  scenario 'Non-authenticated user tries to create question' do
    visit questions_path

    expect(page).to_not have_link 'Ask a question'
  end

  scenario 'Multiple sessions', js: true do
    Capybara.using_session('user') do
      sign_in(user)
      visit questions_path
    end
    Capybara.using_session('guest') do
      visit questions_path
    end

    Capybara.using_session('user') do
      click_on 'Ask a question'
      fill_in 'Title', with: 'Test question'
      fill_in 'Body', with: 'text text'
      click_on 'Ask!'
    end
    Capybara.using_session('guest') do
      expect(page).to have_content 'Test question'
    end
  end
end
