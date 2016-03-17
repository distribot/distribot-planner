
require 'ostruct'
module Distribot

  class Plan
    include TSort
    attr_accessor :name, :tasks
    def initialize(name)
      @name = name
      @tasks = [ ]
    end

    def tsort_each_child(&block)
      tasks.group_by(&:depends_on).each(&block)
    end
    def tsort_each_node(node, &block)
      children(node).each(&block)
    end

    def group(name, options={}, &block)
      task_group = TaskGroup.new(name, options[:depends_on], self)
      task_group.instance_eval(&block)
      self.tasks += task_group.tasks
    end

    def task(name, options={}, &block)
      if tasks.select{ |task| task.name.to_s == name.to_s }.any?
        raise TaskConfigError.new "The name '%s' is already taken"
      end
      task = Task.new(name, options[:depends_on])
      task.instance_eval(&block)
      tasks << task
    end

    def schedule
      grouped = tsort_each_child.map{|parent, tasks| tasks}
      grouped.map{ |g| g.map(&:handler_data) }
    end

    private
    def children(task)
      tasks.select{|t| t.depends_on == task.name}
    end

    def self.all
      @@plans ||= [ ]
      @@plans
    end

    def self.reset!
      @@plans = [ ]
    end
  end
end
