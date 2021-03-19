class SearchesController < ApplicationController
  def search
    @search = Search.new(search_params)
    @search.perform
  end

  def search_params
    params.permit(:type, :search)
  end
end
