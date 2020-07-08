# frozen_string_literal: true

RSpec.describe GameWonState do
  subject { described_class.new(console) }
  let(:console) { Console.new }
  let(:method) { double('Method') }

  context '#interact' do
    before do
      console.create_user(name: 'TestFoo')
      console.create_game(difficulty: 'hell')
      allow(subject).to receive(:ask_save_game)
      allow(subject).to receive(:ask_new_game)
    end

    it { expect { subject.interact }.to output("#{I18n.t(:game_won, code: [])}\n").to_stdout }
  end

  context 'with user input' do
    before { allow($stdin).to receive(:gets).and_return(*input) }
    before { allow(method).to receive(:call) }

    context '#ask_save_game' do
      context 'when saving the game' do
        let(:input) { 'yes' }

        before do
          console.create_user(name: 'TestFoo')
          console.create_game(difficulty: 'hell')
          subject.ask_save_game
        end

        it { expect(console.statistics[0][:name]).to eq('TestFoo') }
        it { expect(subject.ask_save_game).to eq console.game.save_game }
      end

      context 'when input is "no"' do
        let(:input) { 'no' }

        it { expect(subject.ask_save_game).to eq nil }
      end

      context 'when inputting icorrectly' do
        let(:input) { 'incorrect' }

        it 'calls handle_flow' do
          expect(subject).to receive(:handle_flow)
          subject.ask_save_game
        end
      end
    end

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

    context '#handle_flow' do
      let(:input) { 'incorrect' }

      it 'show unexpected command error' do
        expect { subject.handle_flow(input, method) }.to output(I18n.t(:unexpected_command)).to_stdout
      end
    end
  end
end
