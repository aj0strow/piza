require 'piza/version'

module Piza
  
  @unique_name = '_piza_0_'
  
  def self.unique_name
    @unique_name = @unique_name.next
  end
  
end
