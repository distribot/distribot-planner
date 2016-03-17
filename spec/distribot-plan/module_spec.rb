require 'spec_helper'

describe Distribot do
  it 'is a module' do
    expect(Distribot).to be_a Module
  end
  it 'exposes Distribot.plan as a static method on the Distribot module' do
    expect(Distribot).to respond_to :plan
  end
  describe '#plan' do
    before do
      @plan_name = SecureRandom.hex(6)
      expect(Distribot::Plan).to receive(:new).with(@plan_name) do |&block|
        plan = double('plan')
        expect(plan).to receive(:instance_eval)
        expect(Distribot::Plan).to receive(:all) do
          fake_all = double('all')
          expect(fake_all).to receive(:<<).with(plan)
          fake_all
        end
        plan
      end
    end
    it 'creates a new plan and adds it to the collection of plans' do
      # Enough hype:
      Distribot.plan(@plan_name) do; end
    end
  end
end
