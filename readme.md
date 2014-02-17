##Overview:
This is a authentication strategy for [omniauth](https://github.com/intridea/omniauth).

To use it, you should probably use code similar to:

```ruby
use OmniAuth::Builder do
  provider :bigcommerce, bc_client_id, bc_client_secret, scope: 'store_v2'
  OmniAuth.config.full_host = ENV['APP_URL'] || nil
end
```

