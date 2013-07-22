require 'spec_helper'

module API
  extend Piza::API
  
  before :get do
    status 201
  end
  
  get 'hello' do
    'Hello'
  end
end

class App < Sinatra::Base
  set :raise_errors, true
  set :dump_errors, false
  set :show_exceptions, false
  
  register API
end

describe 'Sinatra acceptance test' do
  include Rack::Test::Methods
  
  def app
    App
  end
  
  it 'should respond to /hello' do
    get '/'
    expect(last_response.body).to eq('Hello')
  end
end


