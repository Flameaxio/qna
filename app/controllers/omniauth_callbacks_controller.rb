class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def github
    input = request.env['omniauth.auth']
    @user = User.find_for_oauth(input)
    unless @user
      redirect_to users_authorize_new_path, provider: input[:provider], uid: input[:uid].to_s
      return
    end
    return unless @user.persisted?

    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: 'Github') if is_navigational_format?
  end

  def twitter

  end
end