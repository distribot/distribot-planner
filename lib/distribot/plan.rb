
require 'ostruct'
module Distribot

  class Plan
    include TSort
    attr_accessor :name, :tasks
    def initialize(name)
      @name = name
      @tasks = [ ]
    end

    def group(name, options={}, &block)
      task_group = TaskGroup.new(name, options[:depends_on])
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
      grouped = tsort_each_child.map{|_parent, tasks| tasks}
      grouped.each_with_index.map do |group, idx|
        info = {
          name: 'phase %d/%d' % [ idx + 1, grouped.count ],
          handlers: group.map(&:handler_data)
        }
        info.merge!(is_initial: true) if idx == 0
        info.merge!(is_final: true) if idx + 1 == grouped.count
        info
      end
    end

    def self.all
      @@plans ||= [ ]
      @@plans
    end

    def self.reset!
      @@plans = [ ]
    end

    private

    def tsort_each_child(&block)
      tasks.group_by(&:depends_on).each(&block)
    end
  end
end
