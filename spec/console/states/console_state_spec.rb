# frozen_string_literal: true

RSpec.describe ConsoleState do
  let(:console) { Console.new }
  subject { described_class.new(console) }

  describe '#interact' do
    it { expect { subject.interact }.to raise_error(NotImplementedError) }
  end

  describe '#handle_exit_or_unexpected' do
    let(:method) { double('method') }
    before { allow(method).to receive(:call) }

    context 'when exiting' do
      let(:input) { 'exit' }
      it { expect { subject.handle_exit_or_unexpected(input, method) }.to raise_error(Console::StopGame) }
    end

    context 'when unexpected command' do
      let(:input) { 'unexpected' }
      let(:message) { I18n.t(:unexpected_command) }
      it { expect { subject.handle_exit_or_unexpected(input, method) }.to output(message).to_stdout }
    end
  end
end
