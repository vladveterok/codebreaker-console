# frozen_string_literal: true

RSpec.describe GameMenuState do
  let(:console) { Console.new }
  subject { GameMenuState.new(console) }

  describe '#interact' do
    context 'when starting interraction' do
      let(:input) { StringIO.new(' ') }
      let(:output_message) { I18n.t(:introduction) + I18n.t(:game_menu_options) + I18n.t(:unexpected_command) }
      before do
        $stdin = STDIN
        $stdin = input
        allow(subject).to receive(:loop).and_yield
      end

      it 'shows intro, options, and "unexpected_command"' do
        expect { subject.interact }.to output(output_message).to_stdout
      end
    end

    context 'when input is exit' do
      let(:input) { StringIO.new('exit') }
      before do
        $stdin = STDIN
        $stdin = input
        allow(subject).to receive(:loop).and_yield
      end

      it 'exits' do
        expect { subject.interact }.to raise_error(SystemExit)
      end
    end
  end

  describe '#menu' do
    context 'when input is "rules"' do
      let(:input) { 'rules' }
      it { expect { subject.menu(input) }.to output(I18n.t(:rules)).to_stdout }
    end

    context 'when input is "stats" and stats are empty' do
      let(:input) { 'stats' }
      it 'raises NoSavedData error' do
        expect { subject.menu(input) }.to raise_error(Codebreaker::Validation::NoSavedData)
      end
    end

    context 'when input is incorrectttt' do
      let(:input) { 'statttts' }
      it { expect { subject.menu(input) }.to output(I18n.t(:unexpected_command)).to_stdout }
    end

    context 'when input is "start"' do
      let(:input) { 'start' }
      before { allow(subject).to receive(:loop).and_yield }

      it 'changes state to GameState' do
        expect(console).to receive(:change_state_to).with(:registration_state)
        subject.menu(input)
      end
    end
  end
end
