require 'spec_helper'

describe Distribot::Task do
  it 'is a class' do
    expect(described_class).to be_a Class
  end

  describe 'attributes' do
    it { should respond_to :name }
    it { should respond_to :depends_on }
    it { should respond_to :handler_data }
  end

  describe '#handler(handler)' do
    before do
      @task = described_class.new(:foo)
    end
    context 'when given a' do
      context 'String' do
        before do
          @task.handler('Foo')
        end
        it 'uses a nil version' do
          expect(@task.handler_data[:version]).to be_nil
        end
      end
      context 'Hash' do
        context 'which is valid' do
          before do
            @valid = {
              name: 'Foo',
              version: '0.1.0'
            }
          end
          context 'and includes version' do
            before do
              @task.handler(@valid)
            end
            it 'uses the provided version' do
              expect(@task.handler_data[:version]).to eq @valid[:version]
            end
          end
          context 'and does not include version' do
            before do
              @task.handler(@valid.delete_if{|x,y| x == :version})
            end
            it 'uses a nil version' do
              expect(@task.handler_data[:version]).to be_nil
            end
          end
        end
        context 'which is invalid because' do
          context 'it is a hash with invalid keys' do
            it 'raises an exception' do
              expect{@task.handler(invalid: Hash)}.to raise_error Distribot::TaskConfigError
            end
          end
          context 'is is an unrecognized type' do
            it 'raises an exception' do
              expect{@task.handler(12345)}.to raise_error Distribot::TaskConfigError
            end
          end
        end
      end
    end
  end
end
