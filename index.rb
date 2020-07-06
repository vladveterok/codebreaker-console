# frozen_string_literal: true

require 'pathname'
ENV['DB_PATH'] = "#{Pathname(__FILE__).parent.dirname.realpath}/db/"
ENV['DB_FILE'] = 'results.yml'

require_relative 'bootstrap'

console = Console.new
console.interact
# gamereg = GameRegistrationState.new(console)
# gamereg.interact
