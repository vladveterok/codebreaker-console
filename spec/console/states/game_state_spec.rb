# frozen_string_literal: true

RSpec.describe GameState do
  subject { GameState.new(console) }
  let(:console) { Console.new }

  before do
    console.create_user(name: 'TestFoo')
    console.create_game(difficulty: 'hell')
    allow_any_instance_of(Codebreaker::Game).to receive(:generate_random_code).and_return([4, 4, 4, 4])
    console.game.start_new_game
  end

  context '#menu' do
    let(:input) { 'hint' }

    it 'shows hint' do
      expect { subject.menu(input) }.to output(/[1-6]$/).to_stdout
    end

    it 'shows NoHintsLeft error' do
      subject.menu(input)
      expect { subject.menu(input) }.to raise_error(Codebreaker::Validation::NoHintsLeft)
    end

    it 'stops the game' do
      expect { subject.menu('exit') }.to raise_error(Console::StopGame)
    end

    it 'calles guess_handler' do
      expect(subject).to receive(:guess_handler).with('1234')
      subject.menu('1234')
    end
  end

  context '#guess_handler' do
    context 'when invalid guess is made' do
      let(:input) { %w[11 12345 00 4567 0000] }

      it 'raises InvalidGuess error' do
        input.length.times do |number|
          expect { subject.guess_handler(input[number]) }.to raise_error(Codebreaker::Validation::InvalidGuess)
        end
      end
    end

    context 'when guess is valid' do
      it 'shows player their guess' do
        expect { subject.guess_handler('1234') }.to output(/1234/).to_stdout
      end

      it 'shows player clues' do
        expect { subject.guess_handler('1234') }
          .to output(/#{I18n.t(:show_clues, clues: subject.show_fancy_clues)}/).to_stdout
      end
    end
  end

  context '#change_state_if_won_or_lost' do
    it 'checks if game won or lost' do
      expect(subject).to receive(:change_state_if_won_or_lost)
      subject.menu('4444')
    end

    it 'changes status to "won"' do
      expect(console).to receive(:change_state_to).with(:won_state)
      subject.menu('4444')
    end

    it 'changes status to "lost"' do
      expect(console).to receive(:change_state_to).with(:lost_state)
      console.game.attempts.times { subject.menu('1111') }
    end
  end
end

RSpec.describe GameState do
  subject { GameState.new(console) }
  let(:console) { Console.new }

  before do
    console.create_user(name: 'TestFoo')
    console.create_game(difficulty: 'hell')
    allow_any_instance_of(Codebreaker::Game).to receive(:generate_random_code).and_return([4, 4, 4, 4])
    allow_any_instance_of(GameState).to receive(:loop)
  end

  context 'when initializing the state' do
    after do
      console.change_state_to(:game_state)
    end
    it 'calls "interact" method' do
      expect_any_instance_of(GameState).to receive(:interact)
    end

    it 'calls "play_game" method' do
      expect_any_instance_of(GameState).to receive(:play_game)
    end
  end
end
