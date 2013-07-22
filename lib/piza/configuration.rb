module Piza  
  class Configuration
    attr_accessor :prefix, :postfix
    
    def initialize
      self.prefix = '/'
      self.postfix = ''
    end
  end
  
  class << self
    attr_reader :configuration
    
    def configure
      yield configuration
    end
    
    def reset_configuration!
      @configuration = Configuration.new
    end
  end
  
  reset_configuration!
end