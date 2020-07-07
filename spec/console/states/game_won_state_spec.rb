# frozen_string_literal: true

RSpec.describe GameWonState do
  subject { described_class.new(console) }
  let(:console) { Console.new }
  let(:method) { double('Method') }
  before { allow($stdin).to receive(:gets).and_return(*input) }

  context '#ask_save_game' do
    context 'when saving the game' do
      let(:input) { 'yes' }

      before do
        console.create_user(name: 'TestFoo')
        console.create_game(difficulty: 'hell')
        subject.ask_save_game
      end

      it { expect(console.statistics[0][:name]).to eq('TestFoo') }
    end

    context 'when inputting invalidly' do
      let(:input) { 'incorrect' }
      before { allow(method).to receive(:call) }

      it { expect { subject.handle_flow(input, method) }.to output(I18n.t(:unexpected_command)).to_stdout }
    end
  end

  context '#ask_new_game' do
    let(:input) { 'yes' }

    it 'changes state' do
      expect(console).to receive(:change_state_to).with(:game_state)
      subject.ask_new_game
    end
  end

  context '#ask_new_game_end_game' do
    let(:input) { 'no' }

    it 'ends game' do
      expect { subject.ask_new_game }.to raise_error(SystemExit)
    end
  end

  context '#handle_flow' do
    let(:input) { 'incorrect' }
    before { allow(method).to receive(:call) }

    it 'show unexpected command error' do
      expect { subject.handle_flow(input, method) }.to output(I18n.t(:unexpected_command)).to_stdout
    end
  end
end
