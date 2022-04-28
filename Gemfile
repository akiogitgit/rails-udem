source "https://rubygems.org"
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby "3.0.3"
gem "rails", "~> 7.0.2", ">= 7.0.2.2"
gem "sprockets-rails"
gem "puma", "~> 5.0"
gem "importmap-rails"
gem "turbo-rails"
gem "stimulus-rails"
gem "jbuilder"
gem "bcrypt", "~> 3.1.7"
gem "tzinfo-data", platforms: %i[ mingw mswin x64_mingw jruby ]
gem "bootsnap", require: false
gem "kaminari"
gem "rails-i18n"
gem "gretel"
# gem "refile", require: "refile/rails"
# gem "refile-mini_magick"
gem 'carrierwave'
# gem 'mini_magick'
gem "ransack"
gem "nokogiri", ">= 1.13.4"

group :development, :test do
  gem "debug", platforms: %i[ mri mingw x64_mingw ]
  gem "rails-flog", require: "flog"
  gem "sqlite3", "~> 1.4"
end

group :development do
  gem "web-console"
  gem "pry-byebug"
  gem "annotate"
end

group :test do
  gem "capybara"
  gem "selenium-webdriver"
  gem "webdrivers"
end

group :production do
  gem 'pg'
end