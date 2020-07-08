# frozen_string_literal: true

RSpec.describe GameMenuState do
  let(:console) { Console.new }
  subject { described_class.new(console) }

  describe '#interact' do
    let(:message) { I18n.t(:introduction) }
    before { allow_any_instance_of(described_class).to receive(:choose_from_menu) }

    context 'when starting interraction' do
      it { expect { console.interact }.to output(message).to_stdout }
    end

    context 'when input is exit' do
      it { expect { subject.menu('exit') }.to raise_error(Console::StopGame) }
    end
  end

  describe '#choose_from_menu' do
    after { subject.interact }
    it { expect(subject).to receive(:choose_from_menu) }
  end

  describe '#menu' do
    context 'when input is "rules"' do
      let(:input) { 'rules' }
      it { expect { subject.menu(input) }.to output(I18n.t(:rules)).to_stdout }
    end

    context 'when input is "stats" and stats are empty' do
      let(:input) { 'stats' }
      it { expect { subject.menu(input) }.to raise_error('No saved data is found') }
    end

    context 'when input is incorrectttt' do
      let(:input) { 'statttts' }
      let(:message) { I18n.t(:unexpected_command) }
      let(:method) { double('method') }
      before { allow($stdin).to receive(:gets).and_return(*input) }
      before { allow(method).to receive(:call) }

      it 'show unexpected command error' do
        expect { subject.handle_exit_or_unexpected(input, method) }.to output(message).to_stdout
      end
    end

    context 'when input is "start"' do
      let(:input) { 'start' }
      before { allow(subject).to receive(:loop).and_yield }
      after { subject.menu(input) }

      it { expect(console).to receive(:change_state_to).with(:registration_state) }
    end
  end
end
