source 'https://rubygems.org'

ruby '2.4.0'

git_source(:github) do |repo_name|
  repo_name = "#{repo_name}/#{repo_name}" unless repo_name.include?('/')
  "https://github.com/#{repo_name}.git"
end

gem 'rails', '~> 5.1.4'

gem 'puma', '~> 3.7'
gem 'pg', '~> 0.18'
gem 'elasticsearch-model'
gem 'faraday_middleware-aws-signers-v4'
gem 'friendly_id'
gem 'figaro'
gem 'httparty'
gem 'sass-rails', '~> 5.0'
gem 'uglifier', '>= 1.3.0'
gem 'turbolinks', '~> 5'
gem 'jquery-rails'
gem 'jbuilder', '~> 2.5'
gem 'addressable'
gem 'sanitize', '~> 4.6'

gem 'omniauth'
gem 'omniauth-azure-activedirectory'

gem 'breasal', '~> 0.0.1'

gem 'govuk_elements_rails'
gem 'govuk_frontend_toolkit'
gem 'govuk_template'
gem 'haml-rails'
gem 'kaminari'
gem 'roadie-rails'
gem 'simple_form'
gem 'rails-html-sanitizer', '~> 1.0.4', '>= 1.0.4' # Must be above this version due to CVE-2018-3741

gem 'gov_uk_date_fields', '~> 2.0', '>= 2.0.3'

gem 'rollbar'

gem 'rubocop' # Not in Test group due to: https://github.com/chapmanu/imposter/issues/4

gem 'activerecord-session_store'

gem 'public_activity'

group :test, :development, :staging do
  gem 'faker'
  gem 'factory_girl_rails'
  gem 'rails-controller-testing', '~> 1.0', '>= 1.0.2'
end

group :development do
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console', '>= 3.3.0'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
  gem 'launchy'
end

group :development, :test do
  gem 'byebug', platforms: %i[mri mingw x64_mingw]
  gem 'elasticsearch-extensions'
  gem 'pry'
  gem 'rspec-rails'
  gem 'teaspoon-mocha'
  gem 'coffee-rails'
end

group :test do
  gem 'capybara', '~> 2.13'
  gem 'database_cleaner'
  gem 'poltergeist'
  gem 'rspec-collection_matchers'
  gem 'webmock', '~> 2.1'
  gem 'shoulda-matchers',
      git: 'https://github.com/thoughtbot/shoulda-matchers.git',
      branch: 'rails-5'
  gem 'rack_session_access'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: %i[mingw mswin x64_mingw jruby]
