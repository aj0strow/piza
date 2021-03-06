module Piza
  module API
    attr_accessor :filters, :actions
    
    def registered(app)
      resolve!
      actions.each do |http|
        uri_path = Piza.wrap(http[:path])
        app.send(http[:http], uri_path) do
          http[:actions].map{ |proc| instance_eval(&proc) }.last
        end
      end
    end
    
    [:before, :after].each do |filter|
      define_method(filter) do |*http_verbs, &block|
        filters[filter] << [ http_verbs, block ]
      end
    end
    
    %w(get post put patch delete options link unlink).each do |http_verb|
      define_method(http_verb) do |path = nil, &block|
        actions << { http: http_verb.to_sym, path: path, actions: [ block ] }
      end
    end
    
    def append(path_piece, api = nil, &block)   
      if block_given?
        api = Module.new.extend(Piza::API)
        api.module_eval(&block)
      end
      append_api(path_piece, api)
    end
    
    def resolve!
      unless resolved?
        apply_filters_to_actions(:before, :unshift)
        apply_filters_to_actions(:after, :push)
        self.filters = nil
      end
    end
    
    def resolved?
      filters.nil?
    end
    
    
    private
    
    
    def apply_filters_to_actions(key, ary_method)
      filters[key].each do |verbs, block|
        actions.each do |action|
          action[:actions].send(ary_method, block) if appropriate?(verbs, action[:http])
        end
      end
    end
    
    def appropriate?(verbs, verb)
      verbs.empty? || verbs.include?(verb)
    end
    
    def append_api(path_piece, api)
      api.resolve!
      path_piece = parameterize(path_piece)
      api.actions.each do |action|
        path = parameterize(action[:path])
        action[:path] = [ path_piece, path ].reject{ |s| s.nil? || s.empty? }.join('/')
      end
      actions.concat(api.actions)
    end
    
    def parameterize(path_piece)
      path_piece.is_a?(Symbol) ? ":#{path_piece}" : path_piece
    end
    
    def self.extended(api)
      api.filters = { before: [], after: [] }
      api.actions = []
    end
  end
end