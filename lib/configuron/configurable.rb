module Configuron
  module Configurable
    def configuration
      @configuration ||= self::Configuration.new
    end #TT

    def reset!
      @configuration = self::Configuration.new
    end #TT

    def configure
      yield(configuration)
    end #TT
  end
end
