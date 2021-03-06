require 'spec_helper'

describe Piza do
  describe 'configuration' do
    before :all do
      Piza.configure do |config|
        config.prefix = '/api/'
      end
    end
    
    it 'should configure prefix' do
      expect(Piza.configuration.prefix).to eq('/api/')
    end
    
    after :all do
      Piza.reset_configuration!
    end
  end
  
  it 'should wrap uris' do
    expect(Piza.wrap('hello')).to eq('/hello')
  end
end