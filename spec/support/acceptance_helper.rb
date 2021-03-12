module AcceptanceHelper
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def check_alert(text)
    page.evaluate_script "window.original_alert_function = window.alert"
    page.evaluate_script "window.alert = function(msg) { window.lastAlertMsg = msg; }"
    yield
    last_alert_msg = page.evaluate_script "window.lastAlertMsg"
    last_alert_msg.should == text
  ensure
    page.evaluate_script "window.alert = window.original_alert_function"
  end
end
