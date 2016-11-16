ActionMailer::Base.smtp_settings = {
  :user_name => 'stackish',
  :password => Rails.application.secrets.sendgrid_api_key,
  :domain => '138.68.130.204',
  :address => 'smtp.sendgrid.net',
  :port => 587,
  :authentication => :plain,
  :enable_starttls_auto => true
}
