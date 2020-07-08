# frozen_string_literal: true

require 'pry-byebug'

RSpec.describe GameLostState do
  subject { described_class.new(console) }
  let(:console) { Console.new }
  let(:method) { double('Method') }

  context '#interact' do
    before do
      console.create_user(name: 'TestFoo')
      console.create_game(difficulty: 'hell')
      # allow_any_instance_of(Codebreaker::Game).to receive(:generate_random_code).and_return([4, 4, 4, 4])
      allow(subject).to receive(:ask_new_game)
      # console.game.start_new_game
    end

    it { expect { subject.interact }.to output("#{I18n.t(:game_lost, code: [])}\n").to_stdout }
  end

  context 'whis user input' do
    before { allow($stdin).to receive(:gets).and_return(*input) }
    before { allow(method).to receive(:call) }

    context '#ask_new_game' do
      let(:input) { 'yes' }

      it 'changes state' do
        expect(console).to receive(:change_state_to).with(:game_state)
        subject.ask_new_game
      end
    end

    context '#ask_new_game_end_game' do
      let(:input) { 'no' }

      it 'ends game' do
        expect { subject.ask_new_game }.to raise_error(SystemExit)
      end
    end

    context 'when inputting icorrectly' do
      let(:input) { 'incorrect' }

      it 'calls handle_flow' do
        expect(subject).to receive(:handle_flow)
        subject.ask_new_game
      end
    end

    context 'when calling handle_flow' do
      let(:input) { 'incorrect' }

      it { expect { subject.handle_flow(input, method) }.to output(I18n.t(:unexpected_command)).to_stdout }
    end
  end
end
