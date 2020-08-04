# frozen_string_literal: true

RSpec.describe Console do
  subject(:console) { described_class.new }

  let(:code) { [4, 4, 4, 4] }
  let(:name) { 'TestFoo' }
  let(:start) { ConsoleState::COMMANDS[:start] }
  let(:exit) { ConsoleState::COMMANDS[:exit] }
  let(:yes) { ConsoleState::COMMANDS[:yes] }
  let(:no)  { ConsoleState::COMMANDS[:no] }
  let(:hint) { ConsoleState::COMMANDS[:hint] }

  before { allow($stdin).to receive(:gets).and_return(*input) }

  context 'when play' do
    let(:difficulty) { ConsoleState::DIFFICULTY_NAMES[:easy] }
    let(:total_attempts) { Codebreaker::Game::DIFFICULTIES[:easy][:attempts] }
    let(:hints_total) { Codebreaker::Game::DIFFICULTIES[:easy][:hints] }

    before do
      allow_any_instance_of(Codebreaker::Game).to receive(:generate_random_code).and_return(code)
      console.interact
    end

    context 'when won and saved' do
      let(:input) { [start, name, difficulty, hint, code.join, yes, exit] }

      it { expect(console.statistics[0][:name]).to eq(name) }
      it { expect(console.statistics[0][:difficulty]).to eq(difficulty) }
      it { expect(console.statistics[0][:attempts_total]).to eq(total_attempts) }
      it { expect(console.statistics[0][:attempts_used]).to eq(1) }
      it { expect(console.statistics[0][:hints_total]).to eq(hints_total) }
      it { expect(console.statistics[0][:hints_used]).to eq(1) }
      it { expect(console.state).to be_kind_of(GameWonState) }
    end

    context 'when won and was not saved' do
      let(:name2) { 'TestFoo2' }
      let(:input) { [start, name2, difficulty, code.join, no, exit] }

      it { expect { console.statistics }.to raise_error(Codebreaker::Validation::NoSavedData) }
    end
  end

  context 'when changing states' do
    let(:difficulty) { ConsoleState::DIFFICULTY_NAMES[:hell] }
    let(:total_attempts) { Codebreaker::Game::DIFFICULTIES[:easy][:attempts] }
    let(:hints_total) { Codebreaker::Game::DIFFICULTIES[:easy][:hints] }

    before { console.interact }

    context 'when in Game Menu State' do
      let(:input) { [exit] }

      it 'has GameMenu state' do
        expect(console.state).to be_kind_of(GameMenuState)
      end
    end

    context 'when move to Game Registration State' do
      let(:input) { [start, exit] }

      it 'changes to GameRegistrationState' do
        allow(console.state).to receive(:interact)
        expect(console.state).to be_kind_of(GameRegistrationState)
      end
    end

    context 'when move to GameState' do
      let(:input) { [start, name, difficulty, exit] }

      it 'changes to GameRegistrationState' do
        allow(console.state).to receive(:interact)
        expect(console.state).to be_kind_of(GameState)
      end
    end

    context 'when move to LostState' do
      let(:wrong_guess) { Codebreaker::Game::DIFFICULTIES[:hell][:attempts].times.map { '1111' } }
      let(:input) { [start, name, difficulty, wrong_guess, exit].flatten }

      it 'changes to GameLostState' do
        allow(console.state).to receive(:interact)
        expect(console.state).to be_kind_of(GameLostState)
      end
    end

    context 'when move from LostState to GameState' do
      let(:wrong_guess) { Codebreaker::Game::DIFFICULTIES[:hell][:attempts].times.map { '1111' } }
      let(:input) { [start, name, difficulty, wrong_guess, yes, exit].flatten }

      it 'changes to GameState' do
        allow(console.state).to receive(:interact)
        expect(console.state).to be_kind_of(GameState)
      end
    end
  end
end
