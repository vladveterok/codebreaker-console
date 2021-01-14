# frozen_string_literal: true

RSpec.describe GameMenuState do
  subject(:menu_state) { described_class.new(console) }

  let(:console) { Console.new }

  describe '#interact' do
    let(:message) { I18n.t(:introduction) }

    context 'when starting interraction' do
      it do
        allow(menu_state).to receive(:choose_from_menu)
        expect { menu_state.interact }.to output(message).to_stdout
      end
    end

    context 'when input is exit' do
      it { expect { menu_state.menu(ConsoleState::COMMANDS[:exit]) }.to raise_error(Console::StopGame) }
    end
  end

  describe '#choose_from_menu' do
    after { menu_state.interact }

    it { expect(menu_state).to receive(:choose_from_menu) }
  end

  describe '#menu' do
    let(:commands) { ConsoleState::COMMANDS }
    let(:incorrect_input) { 'incorrect' }

    context 'when input is "rules"' do
      let(:input) { commands[:rules] }

      it { expect { menu_state.menu(input) }.to output(I18n.t(:rules)).to_stdout }
    end

    context 'when input is "stats" and stats are empty' do
      let(:input) { commands[:stats] }
      let(:no_saved_data) { Codebreaker::Validation::NoSavedData }

      it { expect { menu_state.menu(input) }.to raise_error(no_saved_data) }
    end

    context 'when changing the state' do
      let(:input) { commands[:start] }

      it do
        allow(menu_state).to receive(:loop).and_yield
        expect(menu_state).to receive(:change_state_to).with(:registration_state)
        menu_state.menu(input)
      end
    end
  end
end
