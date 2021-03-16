class UsersController < ApplicationController
  def create_authorized
    password = Devise.friendly_token[0, 20]
    @user = User.new(users_params.merge(password: password, password_confirmation: password))
    @user.save!
    redirect_to questions_path, notice: 'Confirm your email!'
  end

  def new_authorized
    @user = User.new(users_params)
    @provider = params[:provider]
    @uid = params[:uid]
    render 'devise/enter_email'
  end

  private

  def users_params
    params.permit(:email, :provider, :uid)
  end
end