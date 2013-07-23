require 'spec_helper'

describe Piza::API do  
  describe 'filters' do
    before :each do
      @module = Module.new do
        extend Piza::API
        before{}
        after(:post, :put){}
      end
    end
    
    it 'should add to before filters' do
      expect(@module.filters[:before]).not_to be_empty
    end
    
    it 'should add to after filters' do
      after_filter = @module.filters[:after].first
      expect(after_filter[0]).to eq([:post, :put])
    end
  end
  
  describe 'http verbs' do
    before :each do
      @module = Module.new do
        extend Piza::API
        get('stuff'){}
      end
    end
    
    it 'should add an element to actions' do
      http = @module.actions[0]
      expect(http[:http]).to eq(:get)
      expect(http[:path]).to eq('stuff')
    end
  end
  
  describe 'resolve!' do
    before :each do
      @module = Module.new do
        extend Piza::API
        before{}
        get{}
        after(:post, :put, :patch){}
      end
      @module.resolve!
    end
    
    it 'should add actions to http verbs' do
      http = @module.actions[0]
      expect(http[:actions].length).to eq(2)
    end
    
    it 'should clear filters' do
      expect(@module.filters).to be_nil
    end
  end
  
  describe 'mount' do
    before :each do
      @module = Module.new do
        extend Piza::API
      end
    end
    
    it 'should add actions' do
      api = Module.new do
        extend Piza::API
        get{}
      end
      @module.mount('test', api)
      expect(@module.actions.count).to eq(1)
    end
    
    it 'should allow a block as well' do
      @module.mount 'test' do
        get do
        end
      end
      expect(@module.actions.count).to eq(1)
    end
    
    it 'should mount infinitely' do
      @module.mount 'a' do
        mount 'b' do
          get('c') {}
        end
      end
      action = @module.actions[0]
      expect(action[:path]).to eq('a/b/c')
    end
    
    it 'should set the path as a symbol' do
      @module.mount :id do
        get{}
      end
      action = @module.actions.first
      expect(action[:path]).to eq(':id')
    end
    
  end
end