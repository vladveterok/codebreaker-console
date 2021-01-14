# frozen_string_literal: true

class Console
  class StopGame < StandardError; end

  include Statistics

  attr_reader :user, :game, :state

  STATES = {
    menu_state: GameMenuState,
    registration_state: GameRegistrationState,
    game_state: GameState,
    won_state: GameWonState,
    lost_state: GameLostState
  }.freeze

  FANCY_CLUES = {
    exact: '+',
    non_exact: '-'
  }.freeze

  def initialize
    @state = states(:menu_state)
    @user = nil
    @game = nil
  end

  def create_user(name:)
    @user = Codebreaker::User.new(name: name)
  end

  def create_game(difficulty:)
    @game = Codebreaker::Game.new(difficulty: difficulty, user: @user)
  end

  def interact
    @state.interact
  end

  def change_state_to(state)
    @state = states(state)
    interact
  end

  def states(state)
    STATES[state].new(self)
  end
end
