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
    case input
    when 'yes' then @console.game.save_game
    when 'no' then nil
    else handle_flow(input, method(:ask_save_game))
    end
  end

  def ask_new_game
    puts I18n.t(:ask_new_game)
    input = $stdin.gets.chomp.downcase
    case input
    when 'yes' then @console.change_state_to(:game_state)
    when 'no' then exit
    else handle_flow(input, method(:ask_new_game))
    end
  end

  def handle_flow(input, method)
    super
  end
end
