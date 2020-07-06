# frozen_string_literal: true

# Needs a class documentation
class Console
  class StopGame < StandardError; end

  include Statistics

  attr_reader :game
  attr_reader :state

  FANCY_CLUES = {
    1 => '+',
    2 => '-',
    nil => ' '
  }.freeze

  def initialize
    @state = states(:menu_state)
  end

  def interact
    @state.interact
  end

  def change_state_to(state)
    @state = states(state)
    interact
  end

  def states(state)
    states ||= {}.merge(
      menu_state: GameMenuState,
      registration_state: GameRegistrationState,
      game_state: GameState,
      won_state: GameWonState,
      lost_state: GameLostState
    )
    states[state].new(self)
  end

  def init_game(difficulty:, user:)
    @game = Codebreaker::Game.new(difficulty: difficulty, user: user)
  end
end
