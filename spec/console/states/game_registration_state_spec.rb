# frozen_string_literal: true

RSpec.describe GameRegistrationState do
  let(:console) { Console.new }
  subject { GameRegistrationState.new(console) }

  describe '#ask_name' do
    before do
      $stdin = STDIN
      $stdin = input
      # allow(subject).to receive(:loop).and_yield
    end

    context 'when input is exit' do
      let(:input) { StringIO.new('exit') }

      it 'exits' do
        expect { subject.ask_name }.to raise_error(SystemExit)
      end
    end
  end
end
