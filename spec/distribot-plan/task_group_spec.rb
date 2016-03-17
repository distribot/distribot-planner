require 'spec_helper'

describe Distribot::TaskGroup do
  it 'is a class' do
    expect(Distribot::TaskGroup).to be_a Class
  end

  describe 'attributes' do
    it { should respond_to :name }
    it { should respond_to :depends_on }
    it { should respond_to :tasks }
  end

  describe '#handler(handler_data)' do
    before do
      @task_group = described_class.new(:foo)
      @task_group.handler(name: 'FooBar', version: '0.1.1')
    end
    it 'should add a properly-configured Distribot::Task to #tasks' do
      expect(@task_group.tasks.count).to eq 1
      task = @task_group.tasks.last
      expect(task.handler_data).to eq(name: 'FooBar', version: '0.1.1')
    end
  end
end
