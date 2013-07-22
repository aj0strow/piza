require 'piza/version'
require 'piza/api'
require 'piza/configuration'

module Piza
  @unique_name = '_piza_0_'
  @configuration = Configuration.new
  
  class << self
    attr_reader :configuration
    
    def unique_name
      @unique_name = @unique_name.next
    end
    
    def configure
      yield @configuration
    end
  end  
end
