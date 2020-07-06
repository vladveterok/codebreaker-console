# frozen_string_literal: true

RSpec.describe GameRegistrationState do
  let(:user) { Codebreaker::User.new(name: 'Foo') }
  let(:game) { Codebreaker::Game.new(difficulty: difficulty, user: user) }
  let(:console) { Console.new }
  subject { GameRegistrationState.new(console) }

  before do
    console.init_game(difficulty: 'easy', user: 'Foo')
  end

  describe '#ask_name' do
    # before do
    # $stdin = STDIN
    # $stdin = input
    # allow(subject).to receive(:loop).and_yield
    # end

    context 'when input is exit' do
      let(:input) { StringIO.new('fr') }

      before do
        allow($stdin).to receive(:gets).and_return('fr')
        subject.ask_name
      end

      it 'exits' do
        expect { subject }.to raise_error(Codebreaker::Validation::GameError)
      end
    end
  end
end
