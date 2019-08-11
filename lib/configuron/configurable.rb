module Configuron
  module Configurable
    def configuration
      @configuration ||= self::Configuration.new
    end #TT

    def reset_configuration!
      @configuration = self::Configuration.new
    end #TT

    alias_method :reset!, :reset_configuration! #TT

    def configure
      yield(configuration)
    end #TT
  end
end
