# frozen_string_literal: true

# Needs a class documentation
class GameLostState < ConsoleState
  def interact
    puts I18n.t(:game_lost, code: @console.game.very_secret_code)

    ask_new_game
  end

  def ask_new_game
    puts I18n.t(:ask_new_game)
    input = $stdin.gets.chomp.downcase
    case input
    when 'yes'
      @console.change_state_to(:game_state)
    when 'no'
      exit
    else
      handle_flow(input, method(:ask_new_game))
    end
  end
end
