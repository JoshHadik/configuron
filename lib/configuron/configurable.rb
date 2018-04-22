module Configuron
  module Configurable
    class UnconfigurableTypeError < StandardError; end

    def self.extended(mod)
      if mod.class == Module
        add_configuration_methods_to(mod)
      else
        raise UnconfigurableTypeError
      end
    end

    def self.add_configuration_methods_to(mod)
      mod.instance_eval do
        def configuration
          @configuration ||= self::Configuration.new
        end
        def reset
          @configuration = self::Configuration.new
        end
        def configure
          yield(configuration)
        end
      end
    end
  end
end
