require 'spec_helper'

describe Distribot::Plan do
  it 'is a class' do
    expect(Distribot::Plan).to be_a Class
  end

  describe 'attributes' do
    let(:subject){ described_class.new(:foo) }
    it { should respond_to :name }
    it { should respond_to :tasks }
    it 'tasks should be an array' do
      expect(described_class.new(:foo).tasks).to be_an Array
    end
  end

  describe '.all' do
    before do
      Distribot.plan :foo do; end
    end
    it 'returns the collection of Plans' do
      expect(described_class.all.map(&:name)).to include :foo
    end
  end

  describe '.reset!' do
    before do
      Distribot.plan :foo do; end
    end
    it 'clears any Plans from the collection' do
      described_class.reset!
      expect(described_class.all).to be_empty
    end
  end

  describe '#group(name, options={}, &block)' do
    before do
      @expected_tasks = ['foo', 'bar']
      expect(Distribot::TaskGroup).to receive(:new) do
        group = double('group')
        expect(group).to receive(:instance_eval)
        expect(group).to receive(:tasks){ @expected_tasks }
        group
      end

      @plan = described_class.new(:foo)
      @tasks = @plan.group(:foo) do; end
    end
    it 'creates a new TaskGroup and reaps the tasks from it' do
      expect(@tasks).to eq @expected_tasks
    end
  end

  describe '#task(name, options={}, &block)' do
    before do
      @plan = described_class.new(:foo)
    end
    context 'when the task name' do
      context 'is not already used' do
        before do
          @name = SecureRandom.hex(6)
          @plan.task(@name) do
            handler 'Foo'
          end
        end
        it 'adds the task to the collection of tasks' do
          expect(@plan.tasks.map(&:name)).to include @name
        end
      end
      context 'is already in use' do
        before do
          @name = SecureRandom.hex(6)
          @plan.task(@name) do
            handler 'Foo'
          end
        end
        it 'raises an exception' do
          expect {
            @plan.task(@name) do
              handler 'Bar'
            end
          }.to raise_error Distribot::TaskConfigError
        end
      end
    end
  end

  describe '#schedule' do
    before do
      Distribot.plan :foo do
        task :step1 do
          handler 'Step1Handler'
        end
        group :step2, depends_on: :step1 do
          handler 'Foo'
          handler 'Bar'
          handler 'Baz'
        end
        task :step3_a, depends_on: :step2 do
          handler 'Bux'
        end
        task :step3_b, depends_on: :step2 do
          handler 'Qux'
        end
        task :step4, depends_on: :step3_b do
          handler 'Flux'
        end
      end
      @expected_schedule = [
        {name: 'phase 1/4', is_initial: true, handlers: [{name: 'Step1Handler'}]},
        {name: 'phase 2/4', handlers: [{name: 'Foo'},{name: 'Bar'},{name: 'Baz'}]},
        {name: 'phase 3/4', handlers: [{name: 'Bux'},{name: 'Qux'}]},
        {name: 'phase 4/4', is_final: true, handlers: [{name: 'Flux'}]}
      ]
    end
    it 'returns a schedule data structure based on the described Plans' do
      expect(Distribot::Plan.all.last.schedule).to eq @expected_schedule
    end
  end

end
