# frozen_string_literal: true

require 'pry-byebug'

RSpec.describe Console do
  subject { described_class.new }
  let(:state) { ConsoleState.new(subject) }

  context 'when play' do
    before do
      allow_any_instance_of(Codebreaker::Game).to receive(:generate_random_code).and_return([4, 4, 4, 4])
      allow($stdin).to receive(:gets).and_return(*input)
      subject.interact
    end

    context 'when won and saved' do
      let(:input) { %w[start TestFoo easy hint 4444 yes exit] }

      it { expect(subject.statistics[0][:name]).to eq('TestFoo') }
      it { expect(subject.statistics[0][:difficulty]).to eq('easy') }
      it { expect(subject.statistics[0][:attempts_total]).to eq(15) }
      it { expect(subject.statistics[0][:attempts_used]).to eq(1) }
      it { expect(subject.statistics[0][:hints_total]).to eq(2) }
      it { expect(subject.statistics[0][:hints_used]).to eq(1) }
    end

    context 'when won and was not saved' do
      let(:input) { %w[start TestFoo2 easy 4444 no exit] }

      it { expect(subject.statistics[6]).to be(nil) }
    end
  end
end
