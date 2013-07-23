require 'spec_helper'

describe 'Prefix and postfix' do
  include Rack::Test::Methods
  
  module API2
    extend Piza::API
  
    append 'users' do
      before :get do
        @user = "User ##{params[:id]}"
      end
      
      get :id do
        @user
      end
    end
  end

  class App2 < Sinatra::Base
    set :raise_errors, true
    set :dump_errors, false
    set :show_exceptions, false
  end
    
  def app
    App2
  end
  
  before :all do
    Piza.configure do |config|
      config.prefix = '/api/'
      config.postfix = '.json'
    end
    App2.register API2
  end
  
  it 'should have api and .json' do
    get '/api/users/5.json'
    expect(last_response.body).to eq('User #5')
  end
  
  after :all do
    Piza.reset_configuration!
  end
end