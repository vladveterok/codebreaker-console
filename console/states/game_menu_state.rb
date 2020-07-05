# frozen_string_literal: true

# Needs a class documentation
class GameMenuState < ConsoleState
  def interact
    puts I18n.t(:introduction)

    loop do
      puts I18n.t(:game_menu_options)

      input = $stdin.gets.chomp.downcase
      # break if input == 'exit'

      menu(input)
    rescue Codebreaker::Validation::GameError => e
      puts e.message
      retry
    end
  end

  def menu(input)
    case input
    when 'start' then @console.change_state_to(:registration_state)
    when 'rules' then puts I18n.t(:rules)
    when 'stats' then puts @console.statistics
    when 'exit' then raise ConsoleState::StopGame
    else
      puts I18n.t(:unexpected_command)
    end
  end
end
