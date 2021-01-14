# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
require 'stringio'

require 'pry'

ENV['DB_PATH'] = "#{Pathname(__FILE__).parent.dirname.realpath}/db/"

require_relative '../bootstrap'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.before do
    stub_const('Codebreaker::FileLoader::FILE_PATH', "#{ENV['DB_PATH']}/results_test.yml")
  end

  config.after do
    File.delete(Codebreaker::FileLoader::FILE_PATH) if File.exist?(Codebreaker::FileLoader::FILE_PATH)
  end
end
