# frozen_string_literal: true

class GameLostState < ConsoleState
  def interact
    puts I18n.t(:game_lost, code: @console.game.very_secret_code)
    ask_new_game
  end

  def ask_new_game
    puts I18n.t(:ask_new_game)
    input = $stdin.gets.chomp.downcase
    return change_state_to(:game_state) if input == COMMANDS[:yes]

    input == COMMANDS[:no] ? exit : handle_exit_or_unexpected(input, method(:ask_new_game))
  end

  # def handle_exit_or_unexpected(input, method)
  #  super
  # end
end
