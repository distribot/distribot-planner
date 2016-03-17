
module Distribot
  class TaskGroup
    attr_accessor :tasks, :name, :depends_on, :plan

    def initialize(name, depends_on, plan)
      self.name = name
      self.depends_on = depends_on
      self.plan = plan
    end

    def handler(handler_data)
      @tasks ||= [ ]
      task_name = '%s.%s' % [ self.name, name ]
      task = Task.new(task_name, self.depends_on)
      task.handler(handler_data)
      @tasks << task
    end
  end
end
