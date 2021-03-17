class UsersController < ApplicationController
  def create_authorized
    password = Devise.friendly_token[0, 20]
    authorization_params = params[:authorization]
    @user = User.new(users_params.merge(password: password, password_confirmation: password))
    @user.authorizations.build(uid: authorization_params[:uid], provider: authorization_params[:provider])
    @user.save!
    redirect_to questions_path, notice: 'Confirm your email!'
  end

  def new_authorized
    @user = User.new(email: users_params[:email])
    @provider = params[:provider]
    @uid = params[:uid]
    render 'devise/enter_email'
  end

  private

  def users_params
    params.permit(:email, :provider, :uid, authorization: [])
  end
end
