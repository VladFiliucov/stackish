source 'https://rubygems.org'

gem 'rails', '4.2.6'
gem 'pg', '~> 0.15'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'coffee-rails', '~> 4.1.0'
gem 'jquery-rails'
gem 'turbolinks', '< 5'
gem 'jbuilder', '~> 2.0'
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'slim-rails'
gem 'dotenv-rails', :require => 'dotenv/rails-now', :groups => [:development, :test]
gem 'devise'
gem 'bootstrap', '~> 4.0.0.alpha3'
gem 'html2slim'
gem 'simple_form'
gem 'carrierwave'
gem 'remotipart'
gem 'cocoon'
gem 'private_pub'
gem 'thin'
gem 'gon'
gem 'responders'
gem 'omniauth'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'cancancan'
gem 'doorkeeper'
gem 'jsonapi-parser', '~> 0.1.1.beta2'
gem 'jsonapi', '~> 0.1.1.beta5'
gem 'active_model_serializers', '~> 0.10.0'
gem 'oj'
gem 'oj_mimic_json'
gem 'whenever'
gem 'sidekiq'
# gem 'sidetiq'
gem 'sinatra', '>=1.3.0', require: nil
gem 'searchkick'

source 'https://rails-assets.org' do
  gem 'rails-assets-tether', '>= 1.1.0'
end

group :development, :test do
  gem 'byebug'
  gem 'rspec-rails'
  gem 'factory_girl_rails'
  gem 'launchy'
  gem 'database_cleaner'
  # gem 'capybara-webkit'
  # gem 'selenium-webdriver'
  gem 'poltergeist'
  # gem 'dotenv-rails'
end

group :development do
  gem 'web-console', '~> 2.0'
  gem 'spring'
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'pry-byebug'
  gem 'capistrano', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-rvm', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-sidekiq', require: false
end

group :test do
  gem 'shoulda-matchers'
  gem 'shoulda-callback-matchers', '~> 1.1.1'
  gem 'capybara'
  gem 'with_model'
  gem 'json_spec'
end
