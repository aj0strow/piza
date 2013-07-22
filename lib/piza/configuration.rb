module Piza
  class Configuration
    attr_accessor :prefix, :postfix
    
    def initialize
      self.prefix = '/'
      self.postfix = ''
    end
  end
end