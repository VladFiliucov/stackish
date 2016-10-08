class Api::V1::ProfilesController < Api::V1::BaseController
  authorize_resource class: User

  def me
    respond_with current_resource_owner
  end

  def all_except_current
    respond_with User.all_except_current(current_resource_owner)
  end
end
