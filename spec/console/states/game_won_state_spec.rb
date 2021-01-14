# frozen_string_literal: true

RSpec.describe GameWonState do
  subject(:won_state) { described_class.new(console) }

  let(:console) { Console.new }
  let(:method) { instance_double('Method') }
  let(:name) { 'a' * Codebreaker::User::NAME_LENGTH.min }

  describe '#interact' do
    before do
      console.create_user(name: name)
      console.create_game(difficulty: ConsoleState::DIFFICULTY_NAMES[:hell])
      allow(won_state).to receive(:ask_save_game)
      allow(won_state).to receive(:ask_new_game)
    end

    it { expect { won_state.interact }.to output("#{I18n.t(:game_won, code: '')}\n").to_stdout }
  end

  context 'with user input' do
    let(:commands) { ConsoleState::COMMANDS }

    before do
      allow($stdin).to receive(:gets).and_return(*input)
      allow(method).to receive(:call)
    end

    context 'when saving the game' do
      let(:input) { commands[:yes] }

      before do
        console.create_user(name: name)
        console.create_game(difficulty: ConsoleState::DIFFICULTY_NAMES[:hell])
        won_state.ask_save_game
      end

      it { expect(console.statistics[0][:name]).to eq(name) }
      it { expect(won_state.ask_save_game).to eq console.game.save_game }
    end

    context 'when inputting icorrectly while saving' do
      let(:input) { 'incorrect' }

      it do
        expect(won_state).to receive(:handle_exit_or_unexpected)
        won_state.ask_save_game
      end
    end

    describe '#ask_new_game' do
      let(:input) { commands[:yes] }

      it do
        expect(won_state).to receive(:change_state_to).with(:game_state)
        won_state.ask_new_game
      end
    end

    describe '#ask_new_game_end_game' do
      let(:input) { commands[:no] }

      it { expect { won_state.ask_new_game }.to raise_error(SystemExit) }
    end

    context 'when inputting icorrectly' do
      let(:input) { 'incorrect' }

      it do
        expect(won_state).to receive(:handle_exit_or_unexpected)
        won_state.ask_new_game
      end
    end

    describe '#handle_exit_or_unexpected' do
      let(:input) { 'incorrect' }
      let(:message) { I18n.t(:unexpected_command) }

      it { expect { won_state.handle_exit_or_unexpected(input, method) }.to output(message).to_stdout }
    end
  end
end
