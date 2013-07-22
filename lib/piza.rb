require 'piza/version'
require 'piza/api'

module Piza
  
  @unique_name = '_piza_0_'
  
  def self.unique_name
    @unique_name = @unique_name.next
  end
  
  
  
end
