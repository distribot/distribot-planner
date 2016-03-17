[![Build Status](https://travis-ci.org/distribot/distribot-planner.svg?branch=master)](https://travis-ci.org/distribot/distribot-planner)
[![Gem Version](https://badge.fury.io/rb/distribot-planner.svg)](https://badge.fury.io/rb/distribot-planner)
[![Code Climate](https://codeclimate.com/github/distribot/distribot-planner/badges/gpa.svg)](https://codeclimate.com/github/distribot/distribot-planner)
[![Test Coverage](https://codeclimate.com/github/distribot/distribot-planner/badges/coverage.svg)](https://codeclimate.com/github/distribot/distribot-planner/coverage)
[![Issue Count](https://codeclimate.com/github/distribot/distribot-planner/badges/issue_count.svg)](https://codeclimate.com/github/distribot/distribot-planner)

# distribot-planner

A planning extension for Distribot handlers.

## Installation

### In your Gemfile

```ruby
gem 'distribot-planner'
```

### Usage

```ruby
require 'distribot-planner'

Distribot.plan :greeting do
  task :get_name do
    handler HandlerTo::GetName
  end

  group :decide_greeting_context, depends_on: :get_name do
    handler HandlerTo::GetTimeOfDay
    handler HandlerTo::GuessGender
    handler HandlerTo::DetermineSocialStatus
  end

  task :assemble_greeting, depends_on: :decide_greeting_context do
    handler HandlerTo::AssembleGreeting
  end

  task :wait_for_proper_timing, depends_on: :assemble_greeting do
    handler HandlerTo::WaitForProperTiming
  end

  task :say_greeting, depends_on: :wait_for_proper_timing do
    handler HandlerTo::SayGreeting
  end
end

```
