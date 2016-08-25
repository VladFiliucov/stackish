class CommentsController < ApplicationController
  before_action :authenticate_user!, only: [:create]
  before_action :set_commentable, only: [:create]

  def create
    @comment = @commentable.comments.new(comment_params)
    @comment.user = current_user
    if @comment.save
      PrivatePub.publish_to "/comments", comment_body: @comment.body.to_json, comment_author: @comment.user.email.to_json, commentable_id: @commentable.id.to_json, commentable_type: commentable_name.to_json
      render nothing: true
    else
      render json: { errors: @comment.errors.full_messages }
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end

  def commentable_name
    params[:commentable].singularize
  end

  def model_klass
    commentable_name.classify.constantize
  end

  def set_commentable
    @commentable = model_klass.find(params["#{commentable_name}_id"])
  end
end
