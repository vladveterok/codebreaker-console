# frozen_string_literal: true

RSpec.describe ConsoleState do
  subject(:console_state) { described_class.new(console) }

  let(:console) { Console.new }

  describe '#interact' do
    it { expect { console_state.interact }.to raise_error(NotImplementedError) }
  end

  describe '#handle_exit_or_unexpected' do
    let(:method) { instance_double('method') }

    before { allow(method).to receive(:call) }

    context 'when exiting' do
      let(:input) { ConsoleState::COMMANDS[:exit] }

      it { expect { console_state.handle_exit_or_unexpected(input, method) }.to raise_error(Console::StopGame) }
    end

    context 'when unexpected command' do
      let(:input) { 'unexpected' }
      let(:message) { I18n.t(:unexpected_command) }

      it { expect { console_state.handle_exit_or_unexpected(input, method) }.to output(message).to_stdout }
    end
  end
end
