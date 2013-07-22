require 'piza/version'
require 'piza/api'
require 'piza/configuration'

module Piza
  @unique_name = '_piza_0_'
  
  class << self
    def unique_name
      @unique_name = @unique_name.next
    end
   
    def wrap(uri)
      configuration.prefix + uri + configuration.postfix
    end
  end
end
