
module Distribot
  class Task < Struct.new(:name, :depends_on, :handler_data)
    def handler(handler)
      case handler.class
      when String, Class
        self.handler_data = {
          name: handler
        }
      when Hash
        handler[:version] ||= nil
        unless handler.keys.sort == [:name, :version]
          raise TaskConfigError.new 'task handler must contain :name and :version'
        end
        self.handler_data = {
          name: handler[:name],
          version: handler[:version]
        }.reject{ |k,v| v.nil? }
      else
        raise TaskConfigError.new 'task handler must be a String or Hash, not a %s' % handler.class.to_s
      end
    end
  end
end
