# frozen_string_literal: true

# Needs a class documentation
class GameWonState < ConsoleState
  def interact
    puts I18n.t(:game_won, code: @console.game.very_secret_code)
    ask_save_game
    ask_new_game
  end
end

private

def ask_save_game
  puts I18n.t(:ask_save_game)
  input = $stdin.gets.chomp.downcase
  case input
  when 'yes'
    @console.game.save_game
  when 'no'
    nil
  else
    handle_flow(input, method(:ask_save_game))
  end
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
