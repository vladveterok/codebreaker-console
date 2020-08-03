# frozen_string_literal: true

class GameRegistrationState < ConsoleState
  def interact
    create_game_instances
    change_state_to(:game_state)
  rescue Codebreaker::Validation::GameError => e
    puts e.message
    retry
  end

  def create_game_instances
    @console.create_user(name: ask_name) unless @console.user
    @console.create_game(difficulty: ask_difficulty)
  end

  def ask_name
    puts I18n.t(:ask_user_name)
    input = $stdin.gets.chomp
    input == 'exit' ? (raise Console::StopGame) : input
  end

  def ask_difficulty
    puts I18n.t(:ask_difficulty)
    input = $stdin.gets.chomp.downcase
    input == 'exit' ? (raise Console::StopGame) : input
  end
end
