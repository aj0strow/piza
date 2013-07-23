# (Leaning Tower Of) Piza

> Build up APIs with ease

There are a ton of great ruby web frameworks that support APIs. Most of them focus on resource controllers or HTTP actions, but I haven't found any that let you do global filters for authentication on POST, PUT, DELETE, let you set resources once and handle 404s, and the like.

### An Example

Suppose you have the Sinatra helpers `json`, `signed_in?` and `persist` for rendering resources as json, checking login status, and saving resources. Then you might want an API like the following:

```ruby
require 'piza'
require './api/posts'

module API
  extend Piza::API
  
  mount 'posts', Posts
  
  before :post, :put, :delete do
    halt 403 unless signed_in?
  end
  
  after :get, :delete do
    json @resource
  end
    
  after :create, :update do
    persist @resource
  end
end

module API::Posts
  extend Piza::API
  
  get do
    @resource = Post.all(limit: 50)
  end
    
  post do
    @resource = Post.new(post_params)
  end
    
  mount :identifier do
    before do
      @resource = Post.first(identifier: params[:identifier])
      halt 404 if @resource.nil?
    end
    
    before :put, :patch, :delete do
      halt 403 unless @resource[:user_id] == current_user.id
    end
      
    get{}
      
    put do
      @resource.update(post_params)
    end

    delete do
      @resource.destroy
    end
  end
end
``` 

To include the API in your app, just register it: `register API`

### Configuration

The default configuration:

```ruby
Piza.configure do |config|
  config.prefix = '/'
  config.postfix = ''
end
```

To have every route start with ``'/api/'`` configure the prefix. To make every route end with `'.json'`, configure the postfix. 

## Notes

If people start using them gem, I'll put it on rubygems. Until then, from the source:

    gem 'piza', github: 'aj0strow/piza'
    
#### Suggested Way To Contribute

1. Fork piza
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request and add some info for me