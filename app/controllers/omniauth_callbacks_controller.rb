class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def facebook
    generic_auth('facebook')
  end

  def twitter
    generic_auth('twitter')
  end

  private

  def generic_auth(kind)
    @user = User.find_for_oauth(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: kind.capitalize) if is_navigational_format?
    else
      redirect_to new_user_registration_path
    end
  end
end
