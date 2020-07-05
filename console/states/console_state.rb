# frozen_string_literal: true

# Needs a class documentation
class ConsoleState
  class StopGame < StandardError; end

  def initialize(console)
    @console = console
  end

  def handle_flow(input, method)
    exit if input == 'exit'
    puts I18n.t(:unexpected_command)
    method.call
  end

  def interact
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
