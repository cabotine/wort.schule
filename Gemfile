source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.1.0"

gem "rails", "~> 7.0.3"
gem "active_record-acts_as"
gem "active_storage_svg_sanitizer"
gem "bootsnap", require: false
gem "cancancan"
gem "devise"
gem "devise-i18n"
gem "draper"
gem "enumerize"
gem "filterrific", github: "metikular/filterrific", branch: "fix/nested-array"
gem "haml"
gem "haml-rails"
gem "heroicon"
gem "humanize_boolean"
gem "image_processing"
gem "importmap-rails"
gem "jbuilder"
gem "kaminari"
gem "liquid"
gem "paper_trail"
gem "pg", "~> 1.4"
gem "propshaft"
gem "puma", "~> 5.6"
gem "rails-i18n"
gem "rb-gravatar"
gem "redis", "~> 4.8" # Use Redis for Action Cable
gem "ruby-vips"
gem "simple_form"
gem "stimulus-rails"
gem "tailwindcss-rails"
gem "turbo-rails"
gem "tzinfo-data", platforms: %i[mingw mswin x64_mingw jruby]
gem "view_component"

group :development do
  gem "better_errors"
  gem "binding_of_caller"
  gem "letter_opener"
  gem "web-console"
end

group :test do
  gem "capybara"
  gem "capybara-screenshot"
  gem "cuprite"
  gem "faker"
  gem "simplecov", require: false
end

group :development, :test do
  gem "debug", platforms: %i[mri mingw x64_mingw]
  gem "factory_bot"
  gem "factory_bot_rails"
  gem "rspec-rails"
  gem "standardrb"
  gem "mina", "1.2.4"
end

group :production do
  gem "unicorn"
end
