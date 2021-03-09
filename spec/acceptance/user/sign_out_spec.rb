require 'rails_helper'

feature 'User sign out', '
  In order to end the session
  As authenticated user
  I should be able to log out
' do
  given(:user) { create(:user) }

  scenario 'Authenticated user logs out' do
    sign_in(user)

    visit root_path
    click_on 'Sign out'
    expect(page).to have_content('Signed out successfully.')
  end
end
