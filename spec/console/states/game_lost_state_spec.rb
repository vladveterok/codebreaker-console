# frozen_string_literal: true

RSpec.describe GameLostState do
  subject(:lost_state) { described_class.new(console) }

  let(:console) { Console.new }
  let(:method) { instance_double('Method') }

  describe '#interact' do
    it do
      console.create_game(difficulty: ConsoleState::DIFFICULTY_NAMES[:hell])
      allow(lost_state).to receive(:ask_new_game)
      expect { lost_state.interact }.to output("#{I18n.t(:game_lost, code: '')}\n").to_stdout
    end
  end

  context 'with user input' do
    let(:commands) { ConsoleState::COMMANDS }

    before do
      allow($stdin).to receive(:gets).and_return(*input)
      allow(method).to receive(:call)
    end

    describe '#ask_new_game' do
      let(:input) { commands[:yes] }

      it do
        expect(lost_state).to receive(:change_state_to).with(:game_state)
        lost_state.ask_new_game
      end
    end

    describe '#ask_new_game_end_game' do
      let(:input) { commands[:no] }

      it { expect { lost_state.ask_new_game }.to raise_error(SystemExit) }
    end

    context 'when inputting icorrectly' do
      let(:input) { 'incorrect' }

      it do
        expect(lost_state).to receive(:handle_exit_or_unexpected)
        lost_state.ask_new_game
      end
    end

    context 'when calling handle_exit_or_unexpected' do
      let(:input) { 'incorrect' }
      let(:message) { I18n.t(:unexpected_command) }

      it { expect { lost_state.handle_exit_or_unexpected(input, method) }.to output(message).to_stdout }
    end
  end
end
