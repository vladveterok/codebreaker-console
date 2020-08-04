# frozen_string_literal: true

RSpec.describe GameState do
  subject(:game_state) { described_class.new(console) }

  let(:console) { Console.new }
  let(:name) { 'TestFoo' }
  let(:game_code) { Codebreaker::Game::CODE_LENGTH.times.map { rand(Codebreaker::Game::DIGIT_MIN_MAX) }.shuffle! }

  before do
    console.create_user(name: name)
    console.create_game(difficulty: ConsoleState::DIFFICULTY_NAMES[:hell])
    allow(console.game).to receive(:generate_random_code).and_return(game_code)
    console.game.start_new_game
  end

  describe '#menu' do
    let(:input) { ConsoleState::COMMANDS[:hint] }

    it 'shows hint' do
      expect { game_state.menu(input) }.to output(/[1-6]$/).to_stdout
    end

    it 'shows NoHintsLeft error' do
      game_state.menu(input)
      expect { game_state.menu(input) }.to raise_error(Codebreaker::Validation::NoHintsLeft)
    end

    it 'stops the game' do
      expect { game_state.menu(ConsoleState::COMMANDS[:exit]) }.to raise_error(Console::StopGame)
    end

    it 'calles guess_handler' do
      expect(game_state).to receive(:guess_handler).with('1234')
      game_state.menu('1234')
    end
  end

  describe '#guess_handler' do
    context 'when guess is invalid' do
      let(:input) { %w[11 12345 4567 0000 foobar] }

      it "raises InvalidGuess error #{:input.length} times" do
        input.length.times do |number|
          expect { game_state.guess_handler(input[number]) }.to raise_error(Codebreaker::Validation::InvalidGuess)
        end
      end
    end

    context 'when guess is valid' do
      let(:clues) { I18n.t(:show_clues, clues: game_state.show_fancy_clues) }
      let(:guess_range) { ConsoleState::DIGIT_MIN_MAX.min..ConsoleState::DIGIT_MIN_MAX.max }
      let(:correct_guess) { ConsoleState::CODE_LENGTH.times.map { rand(guess_range) }.join }

      it 'shows player their guess' do
        expect { game_state.guess_handler(correct_guess) }.to output(/#{correct_guess}/).to_stdout
      end

      it 'shows player clues' do
        expect { game_state.guess_handler('1234') }
          .to output(/#{clues}/).to_stdout
      end
    end
  end

  describe '#change_state_if_won_or_lost' do
    context 'when won' do
      let(:right_guess) { game_code.join }

      after { game_state.menu(right_guess) }

      it { expect(game_state).to receive(:change_state_if_won_or_lost) }
      it { expect(game_state).to receive(:change_state_to).with(:won_state) }
    end

    context 'when lost' do
      let(:wrong_guess) { '1111' }

      it do
        expect(game_state).to receive(:change_state_to).with(:lost_state)
        console.game.attempts.times { game_state.menu(wrong_guess) }
      end
    end
  end
end
