require 'spec_helper'

describe 'Sinatra acceptance test' do
  include Rack::Test::Methods
  
  module MessagesAPI
    extend Piza::API
    
    before :get do
      halt 404, 'not found'
    end
      
    patch :id do
      'Message not found!'
    end
  end
  
  module API
    extend Piza::API
  
    before do
      status 201
    end
  
    get 'hello' do
      'Hello'
    end
    
    mount 'messages', MessagesAPI
  end
  

  class App < Sinatra::Base
    set :raise_errors, true
    set :dump_errors, false
    set :show_exceptions, false
  
    register API
  end
  
  def app
    App
  end
  
  it 'should respond to /hello' do
    get '/hello'
    expect(last_response.status).to eq(201)
    expect(last_response.body).to eq('Hello')
  end
  
  it 'should 404 on messages' do
    get '/messages/5'
    expect(last_response).to be_not_found
  end
end