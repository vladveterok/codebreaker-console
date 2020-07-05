# frozen_string_literal: true

# Needs a class documentation
class GameRegistrationState < ConsoleState
  def interact
    create_game_instances
  end

  def create_game_instances
    user ||= Codebreaker::User.new(name: ask_name) # user_name ||= ask_name
    @console.init_game(user: user, difficulty: ask_difficulty)
    @console.change_state_to(:game_state)
  rescue Codebreaker::Validation::GameError => e
    puts e.message
    retry
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

  def handle_flow
    super
  end
end