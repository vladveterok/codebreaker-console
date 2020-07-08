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
        after { subject.ask_save_game }
        it { expect(subject).to receive(:handle_exit_or_unexpected) }
      end
    end

    context '#ask_new_game' do
      let(:input) { 'yes' }
      after { subject.ask_new_game }
      it { expect(console).to receive(:change_state_to).with(:game_state) }
    end

    context '#ask_new_game_end_game' do
      let(:input) { 'no' }
      it { expect { subject.ask_new_game }.to raise_error(SystemExit) }
    end

    context 'when inputting icorrectly' do
      let(:input) { 'incorrect' }
      after { subject.ask_new_game }
      it { expect(subject).to receive(:handle_exit_or_unexpected) }
    end

    context '#handle_exit_or_unexpected' do
      let(:input) { 'incorrect' }
      let(:message) { I18n.t(:unexpected_command) }

      it { expect { subject.handle_exit_or_unexpected(input, method) }.to output(message).to_stdout }
    end
  end
end
