# frozen_string_literal: true

# Needs a class documentation
class GameWonState < ConsoleState
  def interact
    puts I18n.t(:game_won, code: @console.game.very_secret_code)
    ask_save_game
    ask_new_game
  end

  def ask_save_game
    puts I18n.t(:ask_save_game)
    input = $stdin.gets.chomp.downcase
    return @console.game.save_game if input == 'yes'

    input == 'no' ? nil : handle_exit_or_unexpected(input, method(:ask_save_game))
  end

  def ask_new_game
    puts I18n.t(:ask_new_game)
    input = $stdin.gets.chomp.downcase
    return @console.change_state_to(:game_state) if input == 'yes'

    input == 'no' ? exit : handle_exit_or_unexpected(input, method(:ask_new_game))
  end

  def handle_exit_or_unexpected(input, method)
    super
  end
end
