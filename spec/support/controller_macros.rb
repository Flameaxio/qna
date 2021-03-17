module ControllerMacros
  def sign_in_user
    before do
      @user = create(:user, admin: true)
      @request.env['devise.mapping'] = Devise.mappings[:user]
      authorize @user
    end
  end
end
