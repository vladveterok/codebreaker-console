# frozen_string_literal: true

# Needs a class documentation
class GameMenuState < ConsoleState
  def interact
    puts I18n.t(:introduction)

    loop do
      puts I18n.t(:game_menu_options)

      input = $stdin.gets.chomp.downcase
      exit if input == 'exit'
      menu(input)
    rescue Codebreaker::Validation::GameError => e
      puts e.message
      retry
    end
  end

  def menu(input)
    case input
    when 'start'
      @console.change_state_to(:registration_state)
    when 'rules'
      puts I18n.t(:rules)
    when 'stats'
      puts @console.statistics
    else
      puts I18n.t(:unexpected_command)
    end
  end
end
