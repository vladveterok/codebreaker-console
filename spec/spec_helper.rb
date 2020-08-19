# frozen_string_literal: true

require 'simplecov'
SimpleCov.start
require 'stringio'

require 'pry'

ENV['DB_PATH'] = "#{Pathname(__FILE__).parent.dirname.realpath}/db/"
ENV['DB_FILE'] = 'results_test.yml'

require_relative '../bootstrap'

RSpec.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups

  config.after do
    FileUtils.rm_rf(Dir[ENV['DB_PATH']])
  end
end
