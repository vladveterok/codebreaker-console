# frozen_string_literal: true

RSpec.describe GameRegistrationState do
  let(:console) { Console.new }
  let(:user) { instance_double('User') }
  subject { described_class.new(console) }

  describe '#interact' do
    before do
      console.create_user(name: 'TestFoo')
      allow(subject).to receive(:change_state_to)
      allow(console).to receive(:create_game)
      allow(subject).to receive(:ask_difficulty)
    end
    after { subject.interact }

    it { expect(subject).to receive(:create_game_instances) }

    it { expect(subject).not_to receive(:ask_name) }
  end

  describe '#create_game_instances' do
    before { allow(console).to receive(:create_user) }
    before { allow(console).to receive(:create_game) }
    after { subject.create_game_instances }

    it 'calls ask_name' do
      allow(subject).to receive(:ask_difficulty)
      expect(subject).to receive(:ask_name)
    end

    it 'calls ask_difficulty' do
      allow(subject).to receive(:ask_name)
      expect(subject).to receive(:ask_difficulty)
    end
  end

  describe 'with inputs' do
    before { allow($stdin).to receive(:gets).and_return(*input) }

    describe '#ask_name and #ask difficulty' do
      context 'when input is exit' do
        let(:input) { 'exit' }
        it { expect { subject.ask_name }.to raise_error(Console::StopGame) }
        it { expect { subject.ask_difficulty }.to raise_error(Console::StopGame) }
      end
    end

    describe '#create_game_instances' do
      let(:input) { 'fo' }

      it { expect { subject.create_game_instances }.to raise_error(Codebreaker::Validation::InvalidName) }

      it 'raises UnknownDifficulty error' do
        allow_any_instance_of(Console).to receive(:create_user).with(name: input)
        expect { subject.create_game_instances }.to raise_error(Codebreaker::Validation::UnknownDifficulty)
      end
    end
  end
end
