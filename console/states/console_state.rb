# frozen_string_literal: true

class ConsoleState
  COMMANDS = {
    exit: 'exit',
    start: 'start',
    rules: 'rules',
    stats: 'stats',
    hint: 'hint',
    yes: 'yes',
    no: 'no'
  }.freeze

  DIFFICULTIES = {
    easy: 'Easy - 15 attempts, 2 hints',
    medium: 'Medium - 10 attempts, 1 hint',
    hell: 'Hell - 5 attempts, 1 hint (and you\'re actually going to hell if lose'
  }.freeze

  CODE_LENGTH = 4
  # DIGIT_MAX = 6
  DIGIT_MIN_MAX = (1..6).freeze

  def initialize(console)
    @console = console
  end

  def handle_exit_or_unexpected(input, method)
    raise Console::StopGame if input == COMMANDS[:exit]

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
