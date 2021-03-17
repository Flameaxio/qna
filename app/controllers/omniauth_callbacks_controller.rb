class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def authorize(type)
    input = request.env['omniauth.auth']
    @user = User.find_for_oauth(input)
    unless @user
      redirect_to users_authorize_new_path(provider: input[:provider], uid: input[:uid].to_s)
      return
    end
    sign_in_and_redirect @user, event: :authentication
    set_flash_message(:notice, :success, kind: type) if is_navigational_format?
  end

  def github
    authorize('Github')
  end

  def twitter
    authorize('Twitter')
  end
end
