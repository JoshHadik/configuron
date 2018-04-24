module Configuron
  module Configurable
    class UnconfigurableTypeError < StandardError; end

    def self.extended(mod)
      extended_at_path, = caller[0].partition(":")
      if mod.class == Module

        add_configuration_methods_to(mod, extended_at_path)
      else
        raise UnconfigurableTypeError
      end
    end

    def self.add_configuration_methods_to(mod, extended_at_path)
      eval_proc = Proc.new do |path|
        @configuron_root_path = path
        def root
          Pathname.new(File.dirname @configuron_root_path)
        end
        def configuration
          @configuration ||= self::Configuration.new
        end
        def reset!
          @configuration = self::Configuration.new
        end
        def configure
          yield(configuration)
        end
      end
      mod.instance_exec(extended_at_path, &eval_proc)
    end
  end
end
