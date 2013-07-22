module Piza
  module API
    attr_accessor :filters, :actions
    
    def registered(app)
    end
    
    [:before, :after].each do |filter|
      define_method(filter) do |*http_verbs, &block|
        filters[filter] << [ Piza.unique_name, http_verbs, block ]
      end
    end
    
    %w(get post put patch delete options link unlink).each do |http_verb|
      define_method(http_verb) do |path = nil, &block|
        actions << { http: http_verb.to_sym, path: path, actions: [ block ] }
      end
    end
    
    def mount(path_piece, api = nil, &block)
      if block_given?
        api = Module.new do
          extend Piza::API
          module_eval(&block)
        end
      end
      mount_api(path_piece, api)
    end
    
    def resolve!
      filters[:before].each do |_, verbs, block|
        actions.each do |action|
          action[:actions].unshift(block) if appropriate?(verbs, action[:http])
        end
      end
      filters[:after].each do |_, verbs, block|
        actions.each do |action|
          action[:actions].push(block) if appropriate?(verbs, action[:http])
        end
      end
      self.filters = nil
    end
            
    private
    
    def mount_api(path_piece, api)
      api.resolve!
      api.actions.each do |action|
        action[:path] = [ path_piece, action[:path] ].compact.join('/')
      end
      actions.concat(api.actions)
    end
    
    def appropriate?(verbs, verb)
      verbs.empty? || verbs.include?(verb)
    end
    
    def self.extended(api)
      api.filters = { before: [], after: [], http: [] }
      api.actions = []
    end
    
  end
end