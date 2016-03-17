
module Distribot
  class TaskGroup < Struct.new(:name, :depends_on)
    attr_accessor :tasks

    def handler(handler_data)
      @tasks ||= [ ]
      task_name = '%s.%s' % [ self.name, name ]
      task = Task.new(task_name, self.depends_on)
      task.handler(handler_data)
      @tasks << task
    end
  end
end
