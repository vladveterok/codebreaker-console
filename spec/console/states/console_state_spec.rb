# frozen_string_literal: true

RSpec.describe ConsoleState do
  let(:console) { Console.new }
  subject { ConsoleState.new(console) }

  describe '#interact' do
    it 'raises NotImplementedError' do
      expect { subject.interact }.to raise_error(NotImplementedError)
    end
  end
end
