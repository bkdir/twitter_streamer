source 'https://rubygems.org'

gem 'rails',       '5.0.0.1'
gem 'twitter',     '6.0.0'
gem 'faker',       '1.7.1'
gem 'bcrypt',      '3.1.11'  # Use ActiveModel has_secure_password
gem 'puma',        '3.4.0'   # Use Puma as the app server
gem 'sass-rails',  '5.0.6'   # Use SCSS for stylesheets

gem 'bootstrap-sass',          '3.3.6'
gem 'will_paginate',           '3.1.0'
gem 'bootstrap-will_paginate', '0.0.10' # configures will_paginate to use Bootstrap's pagination styles
gem 'font-awesome-rails',     '4.7.0.1'

gem 'uglifier',     '3.0.0'   # Use Uglifier as compressor for JavaScript assets
gem 'coffee-rails', '4.2.1'  # Use CoffeeScript for .coffee assets and views

gem 'jquery-rails', '4.1.1'
gem 'jbuilder',     '2.4.1' # Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder

gem 'turbolinks', '5.0.1'  # Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks

group :development, :test do
  gem 'byebug',  '9.0.0', platform: :mri  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
end

group :development do
  # Access an IRB console on exception pages or by using <%= console %> anywhere in the code.
  gem 'web-console',    '3.1.1'  
  gem 'listen',         '3.0.8'
  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring',                '1.7.2'  
  gem 'spring-watcher-listen', '2.0.0'
end

group :test do
    gem 'rails-controller-testing', '0.1.1'
    gem 'minitest-reporters',       '1.1.9'
    gem 'guard',                    '2.13.0'
    gem 'guard-minitest',           '2.4.4'
end

group :production, :development, :test do
  gem 'pg', '0.18.4'
end

# Windows does not include zoneinfo files, so bundle the tzinfo-data gem
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

