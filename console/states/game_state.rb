# frozen_string_literal: true

# Needs a class documentation
class GameState < ConsoleState
  def interact
    @console.game.start_new_game
    play_game
  end

  def play_game
    loop do
      puts I18n.t(:ask_guess)
      input = $stdin.gets.chomp

      menu(input)

      # break if @console.game.lost?
    rescue Codebreaker::Validation::GameError => e
      puts e.message
      retry
    end
  end

  def menu(input)
    return puts I18n.t(:show_hint, hint: @console.game.show_hint) if input == 'hint'

    input == 'exit' ? (raise Console::StopGame) : guess_handler(input)

    change_state_if_won_or_lost
  end

  def guess_handler(input)
    puts I18n.t(:your_guess_is, guess: input)
    @console.game.guess(input)
    # puts "very secret code is #{@console.game.very_secret_code}" # for testing
    puts I18n.t(:show_clues, clues: show_fancy_clues)
  end

  def show_fancy_clues
    @console.game.clues.map { |clue| Console::FANCY_CLUES[clue] }
  end

  def change_state_if_won_or_lost
    @console.change_state_to(:won_state) if @console.game.won?
    @console.change_state_to(:lost_state) if @console.game.lost?
  end
end
