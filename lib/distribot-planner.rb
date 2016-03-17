
require 'facets/module/cattr'
require 'tsort'
require 'distribot/plan'
require 'distribot/task'

module Distribot
  class TaskConfigError < StandardError; end

  def self.plan(name, &block)
    plan = Plan.new(name)
    plan.instance_eval(&block)
    Plan.all << plan
    plan
  end

end
