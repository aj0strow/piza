# (Leaning Tower Of) Piza

![](https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-ash3/944296_10151808876277269_290364435_n.jpg)

APIs have a lot of repetitive logic. Records need to be queried and found. Permissions need to be checked for certiain actions. After observing much of this is related to where in the API you are, I thought it would be a good idea to kind of build modules of an API on top of previous logic dependent on the URI.

For example, with a `/users` start to the URI, if you were to append `/:id` to that, every action is likely to query the database for the User with that :id, and would want to throw a 404 if it wasn't found. *Piza* works by applying before and after filters to specific HTTP verbs for the URI, and all things that build on top of it, or are appended to it in URI terms. 

### An Example

Suppose you have the Sinatra helpers `json`, `signed_in?` and `persist` for rendering resources as json, checking login status, and saving resources. Then you might want an API like the following:

```ruby
# lib/api.rb

require 'piza'
require 'lib/api/posts'

module API
  extend Piza::API
  
  append 'posts', Posts
  
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

# lib/api/posts.rb

module API
  module Posts
    extend Piza::API
    
    get do
      @resource = Post.all(limit: 50)
    end
      
    post do
      @resource = Post.new(post_params)
    end
      
    append :identifier do
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