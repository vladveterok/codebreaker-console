# frozen_string_literal: true

# Needs a class documentation
class GameState < ConsoleState
  def interact
    @console.game.start_new_game
    loop do
      change_state

      puts I18n.t(:ask_guess)
      input = $stdin.gets.chomp

      menu(input)

    rescue Codebreaker::Validation::GameError => e
      puts e.message
      retry
    end
  end

  private

  def menu(input)
    case input
    when 'hint'
      puts I18n.t(:show_hint, hint: @console.game.show_hint)
    when 'exit'
      raise ConsoleState::StopGame # exit
    else
      game_handler(input)
    end
  end

  def game_handler(input)
    puts I18n.t(:your_guess_is, guess: input)
    @console.game.guess(input)
    puts "very secret code is #{@console.game.very_secret_code}" # for testing
    puts I18n.t(:show_clues, clues: show_clues)
  end

  def show_clues
    @console.game.clues.map { |clue| Console::FANCY_CLUES[clue] }
  end

  def change_state
    @console.change_state_to(:won_state) if @console.game.won?
    @console.change_state_to(:lost_state) if @console.game.lost?
  end
end
