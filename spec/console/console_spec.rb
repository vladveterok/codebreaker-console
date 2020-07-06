# frozen_string_literal: true

RSpec.describe Console do
  subject { described_class.new }
  let(:state) { ConsoleState.new(subject) }
  let(:game) { Game.new(difficulty) }

  context 'when win' do
    before do
      allow_any_instance_of(Codebreaker::Game).to receive(:generate_random_code).and_return([4, 4, 4, 4])
      allow($stdin).to receive(:gets).and_return('start', 'Foo', 'easy', 'hint', '4444', 'exit')
      subject.interact
    end

    it { expect(subject).to be_a(Console) }

    it { expect(Codebreaker::Game.load).to include(game.class) }
  end
end
