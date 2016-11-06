class SearchesController < ApplicationController
  skip_authorization_check

  def index
    if !params[:by].blank?
      @by = params[:by].constantize
      @search_results = Searchkick.search(params.fetch(:q, "*"), index_name: [@by])
    else
      @search_results = Searchkick.search(params.fetch(:q, "*"), index_name: [Question, Answer, Comment, User])
    end
  end
end
