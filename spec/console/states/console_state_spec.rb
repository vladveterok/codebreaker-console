# frozen_string_literal: true

RSpec.describe ConsoleState do
  let(:console) { Console.new }
  subject { ConsoleState.new(console) }

  describe '#interact' do
    it 'raises NotImplementedError' do
      expect { subject.interact }.to raise_error(NotImplementedError)
    end
  end

  describe '#handle_flow' do
    let(:method) { double('method') }
    it 'raises Console::StopGame' do
      input = 'exit'
      expect { subject.handle_flow(input, method) }.to raise_error(Console::StopGame)
    end
    it 'show "unexpected_command"' do
      allow(method).to receive(:call)
      input = 'brgf'
      expect { subject.handle_flow(input, method) }.to output(I18n.t(:unexpected_command)).to_stdout
    end
  end
end
