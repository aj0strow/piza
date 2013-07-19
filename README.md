# (Leaning Tower Of) Piza

> Build up APIs with ease

There are a ton of great ruby web frameworks that support APIs. Most of them focus on resource controllers or HTTP actions, but I haven't found any that let you do global filters for authentication on POST, PUT, DELETE, let you set resources once and handle 404s, and the like.

### An Example

```ruby
require 'piza'

module API
  extend Piza::API

  def self.mounted
    before :post, :put, :delete do
      halt 403 unless signed_in?
    end
  
    mount 'posts', Posts
    
    after :get, :delete do
      json @resource
    end
    
    after :create, :update do
      persist @resource
    end

    def json(resource)
      status 200
      MultiJson.dump(resource)
    end
    
    def persist(resource)
      if resource.save
        json resource
      else
        status 422
        MultiJson.dump(resource.errors)
      end
    end
  end
end

module API::Posts
  extend Piza::API

  def self.mounted
    def post_params
      params.require(:post).permit(:title, :content)
    end
    
    get do
      @resource = Post.all(limit: 50)
    end
    
    post do
      @resource = Post.new(post_params)
    end
    
    mount :identifier do
      before do
        find_hash = { identifier: params[:identifier] }
        find_hash.merge! user_id: current_user.id if signed_in?
        @resource = Post.first(find_hash)
        halt 404 if @post.nil?
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

## Notes

If people start using them gem, I'll put it on rubygems. Until then, from the source:

    gem 'piza', github: 'aj0strow/piza'
    
#### Suggested Way To Contribute

1. Fork piza
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request and add some info for me