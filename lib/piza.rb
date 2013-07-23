require 'piza/version'
require 'piza/api'
require 'piza/configuration'

module Piza
  def self.wrap(uri)
    configuration.prefix + uri + configuration.postfix
  end
end
