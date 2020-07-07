# frozen_string_literal: true

RSpec.describe GameRegistrationState do
  let(:console) { instance_double('Console') }
  subject { GameRegistrationState.new(console) }

  describe '#ask_name' do
    context 'when input is exit' do
      before do
        allow(subject).to receive(:ask_name).and_return('fr')
        subject.ask_name
      end

      it 'return string' do
        expect(subject.ask_name).to be('fr')
      end
    end
  end

  describe '#ask_difficulty' do
    context 'when input is exit' do
      before do
        allow(subject).to receive(:ask_difficulty).and_return('fr')
        subject.ask_difficulty
      end

      it 'return string' do
        expect(subject.ask_difficulty).to be('fr')
      end
    end
  end

  describe '#create_game_instances' do
    let(:input) { %w[fo easy] }
    let(:user) { instance_double('User', name: input[0]) }

    before do
      allow($stdin).to receive(:gets).and_return(*input)
      allow(console).to receive(:init_game).with(user: user, difficulty: input[1])
      # allow(subject).to receive(:ask_difficulty).and_return('easy')
      # allow(subject).to receive(:create_game_instances).and_raise("Codebreaker::Validation::GameError")
      subject.create_game_instances
    end
    it 'raises error for invalid name' do
      expect { subject.create_game_instances }.to raise_error(Codebreaker::Validation::GameError)
    end
  end
end
