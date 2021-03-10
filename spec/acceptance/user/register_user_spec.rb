require 'acceptance/acceptance_helper'

feature 'Create question', '
  In order to have access to all functionality of the system
  As a guest
  I should be able to register
' do
  before do
    visit root_path
    click_on 'Sign in'
    click_on 'Sign up'
    fill_in 'Email', with: 'user@test.com'
    fill_in 'Password', with: '123456'
  end
  scenario 'Guest creates new account' do
    fill_in 'Password confirmation', with: '123456'
    click_on 'Sign up'
    expect(page).to have_content 'Welcome! You have signed up successfully.'
  end

  scenario 'Guest enters wrong data' do
    fill_in 'Password confirmation', with: '12345'
    click_on 'Sign up'
    expect(page).to have_content "Password confirmation doesn't match Password"
  end
end
