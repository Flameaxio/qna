class SearchesController < ApplicationController
  def search
    if search_params[:search].include?('@')
      redirect_to root_path, alert: "Search cannot contain '@'"
      return
    end
    @search = Search.new(search_params)
    @search.perform
  end

  def search_params
    params.permit(:type, :search)
  end
end
