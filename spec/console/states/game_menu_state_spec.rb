# frozen_string_literal: true

RSpec.describe GameMenuState do
  let(:console) { Console.new }
  subject { GameMenuState.new(console) }

  describe '#interact' do
    context 'when starting interraction' do
      let(:output_message) { I18n.t(:introduction) }
      before { allow_any_instance_of(described_class).to receive(:choose_from_menu) }

      it 'shows intro message' do
        expect { console.interact }.to output(output_message).to_stdout
      end
    end

    context 'when input is exit' do
      it 'exits' do
        expect { subject.menu('exit') }.to raise_error(Console::StopGame)
      end
    end
  end

  describe '#choose_from_menu' do
    it 'calls choose_from_menu' do
      expect(subject).to receive(:choose_from_menu)
      subject.interact
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
        expect { subject.menu(input) }.to raise_error('No saved data is found')
      end
    end

    context 'when input is incorrectttt' do
      let(:input) { 'statttts' }
      let(:method) { double('method') }
      before { allow($stdin).to receive(:gets).and_return(*input) }
      before { allow(method).to receive(:call) }
      it 'show unexpected command error' do
        expect { subject.handle_flow(input, method) }.to output(I18n.t(:unexpected_command)).to_stdout
      end
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
