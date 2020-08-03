# frozen_string_literal: true

class ConsoleState
  def initialize(console)
    @console = console
  end

  def handle_exit_or_unexpected(input, method)
    raise Console::StopGame if input == 'exit'

    puts I18n.t(:unexpected_command)
    method.call
  end

  def change_state_to(state)
    @console.change_state_to(state)
  end

  def interact
    raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
  end
end
