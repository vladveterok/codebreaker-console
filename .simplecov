# frozen_string_literal: true

SimpleCov.start do
  enable_coverage :branch
  add_filter 'spec/'
end

SimpleCov.minimum_coverage line: 90, branch: 80
