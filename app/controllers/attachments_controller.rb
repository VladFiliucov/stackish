class AttachmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_attachment

  authorize_resource

  def destroy
    if current_user.author?(@attachment.attachable)
      @attachment.destroy
    else
      flash.now[:notice] =  'Not your entry'
    end
  end

  private

  def set_attachment
    @attachment = Attachment.find(params[:id])
  end
end
