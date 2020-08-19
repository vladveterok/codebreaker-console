# frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }

ruby '2.7.0'

# gem 'codebreaker', git: 'https://github.com/vladveterok/codebreaker-gem.git', branch: 'develop'
gem 'codebreaker', git: 'https://github.com/vladveterok/codebreaker-gem.git', branch: 'gem/iteration2'
gem 'i18n'

group :development, :test do
  gem 'fasterer', '~> 0.8.3', require: false
  gem 'lefthook', '~> 0.7.2', require: false
  gem 'pry-byebug'
  gem 'rspec', '~> 3.2'
  gem 'rubocop', require: false
  gem 'rubocop-rspec', '~> 1.40.0'
end

group :test do
  gem 'simplecov', '~> 0.18.5', require: false
end
