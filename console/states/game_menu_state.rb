# frozen_string_literal: true

# Needs a class documentation
class GameMenuState < ConsoleState
  def interact
    puts I18n.t(:introduction)

    choose_from_menu
  rescue Codebreaker::Validation::GameError => e
    puts e.message
    retry
  rescue Console::StopGame
    puts I18n.t(:bye_bye)
  end

  def choose_from_menu
    loop do
      puts I18n.t(:game_menu_options)

      input = $stdin.gets.chomp.downcase

      menu(input)
    end
  end

  def menu(input)
    case input
    when 'start' then @console.change_state_to(:registration_state)
    when 'rules' then puts I18n.t(:rules)
    when 'stats' then puts @console.statistics
    else handle_exit_or_unexpected(input, method(:choose_from_menu))
    end
  end

  def handle_exit_or_unexpected(input, method)
    super
  end
end
