# frozen_string_literal: true

RSpec.describe Console do
  subject(:console) { described_class.new }

  context 'when initializing' do
    it { expect(console.state).to be_a(GameMenuState) }
  end
end
