# frozen_string_literal: true

RSpec.describe GameRegistrationState do
  subject(:registration_state) { described_class.new(console) }

  let(:console) { Console.new }

  describe '#interact' do
    it do
      allow(console).to receive(:change_state_to)
      expect(registration_state).to receive(:create_game_instances)

      registration_state.interact
    end
  end

  describe '#create_game_instances' do
    before do
      allow(console).to receive(:create_user)
      allow(console).to receive(:create_game)
    end

    after { registration_state.create_game_instances }

    it 'calls ask_name' do
      allow(registration_state).to receive(:ask_difficulty)
      expect(registration_state).to receive(:ask_name)
    end

    it 'calls ask_difficulty' do
      allow(registration_state).to receive(:ask_name)
      expect(registration_state).to receive(:ask_difficulty)
    end
  end

  describe 'with inputs' do
    before { allow($stdin).to receive(:gets).and_return(*input) }

    describe '#ask_name and #ask difficulty' do
      let(:input) { ConsoleState::COMMANDS[:exit] }

      it { expect { registration_state.ask_name }.to raise_error(Console::StopGame) }
      it { expect { registration_state.ask_difficulty }.to raise_error(Console::StopGame) }
    end

    describe '#create_game_instances' do
      let(:input) { 'f' * (Codebreaker::User::NAME_LENGTH.min - 1) }

      it { expect { registration_state.create_game_instances }.to raise_error(Codebreaker::Validation::InvalidName) }

      it 'raises UnknownDifficulty error' do
        allow(console).to receive(:create_user).with(name: input)
        expect { registration_state.create_game_instances }.to raise_error(Codebreaker::Validation::UnknownDifficulty)
      end
    end
  end

  context 'when changing the state' do
    let(:name) { 'TestName' }
    let(:difficulty) { ConsoleState::DIFFICULTY_NAMES[:easy] }
    let(:input) { [name, difficulty] }

    before { allow($stdin).to receive(:gets).and_return(*input) }

    it do
      expect(registration_state).to receive(:change_state_to).with(:game_state)
      registration_state.interact
    end
  end
end
