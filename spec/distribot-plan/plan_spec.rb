require 'spec_helper'

describe Distribot::Plan do
  it 'is a class' do
    expect(Distribot::Plan).to be_a Class
Distribot.plan :greeting do
  task :get_name do
    handler 'HandlerTo::GetName'
  end

  group :decide_greeting_context, depends_on: :get_name do
    handler 'HandlerTo::GetTimeOfDay'
    handler 'HandlerTo::GuessGender'
    handler 'HandlerTo::DetermineSocialStatus'
  end

  task :assemble_greeting, depends_on: :decide_greeting_context do
    handler 'HandlerTo::AssembleGreeting'
  end

  task :wait_for_proper_timing, depends_on: :assemble_greeting do
    handler 'HandlerTo::WaitForProperTiming'
  end

  task :say_greeting, depends_on: :wait_for_proper_timing do
    handler 'HandlerTo::SayGreeting'
  end
end
byebug
puts 'now....'

  end
end
