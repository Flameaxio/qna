require 'acceptance/acceptance_helper'



feature 'User sign in with github', '
  In order to speed up registration
  As a guest
  I should be able to register using my github account
' do
  given!(:user) { create(:user) }

  scenario 'user already has authorization' do
    visit questions_path
    click_on 'Sign in'
    expect(page).to have_content('Sign in with GitHub')
    mock_auto_hash
    click_on 'Sign in with GitHub'
    fill_in 'Email', with: 'new@user.com'
    click_on 'Submit'
    open_email('new@user.com')
    visit questions_path
    expect(User.last.email).to eq 'new@user.com'
  end
end
