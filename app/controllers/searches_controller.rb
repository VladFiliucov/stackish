class SearchesController < ApplicationController
  skip_authorization_check

  def index
    if !params[:by].blank?
      @by = params[:by].constantize
    else
      @by = [Question, Answer, Comment, User]
    end
    @search_results = Searchkick.search(params.fetch(:q, "*"), index_name: @by)
  end
end
