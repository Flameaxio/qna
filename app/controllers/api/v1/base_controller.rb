class Api::V1::BaseController < ApplicationController
  before_action :doorkeeper_authorize!

  respond_to :json

  def default_serializer_options
    {root: true}
  end

  protected

  def current_resource_owner
    @current_resource_owner ||= User.find(doorkeeper_token.resource_owner_id) if doorkeeper_token
  end

  def authenticate_user!
    if doorkeeper_token.try(:resource_owner_id)
      RequestStore.store[:current_user] = User.find(doorkeeper_token.resource_owner_id)
    end

    return if current_user

    render json: { errors: ['User is not authenticated!'] }, status: :unauthorized
  end

  def current_user
    RequestStore.store[:current_user]
  end
end
