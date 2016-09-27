module AcceptanceHelpers
  def sign_in(user)
    visit new_user_session_path
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_on 'Log in'
  end

  def mock_auth_hash(provider)
    OmniAuth.config.mock_auth[provider.to_sym] = OmniAuth::AuthHash.new({
      'provider' => provider,
      'uid' => '123545',
      'info' => {
        'name' => 'mockuser',
        'email' => 'user@email.com'
      },
      'credentials' => {
        'token' => 'mock_token',
        'secret' => 'mock_secret'
      }
    })
  end
end
