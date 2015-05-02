OMonban
======

OMonban is a reverse proxy that provides authentication using OAuth providers.  
Demo application running here: https://omonban.herokuapp.com/


## Getting Started

1. `git clone` this project
1. rename `config/application.yml.sample` to `/path/to/config.yml`
1. edit `config.yml` and `export CONFIG_FILE=/path/to/config.yml`
1. `bundle install`
1. `bundle exec rackup` or `bundle exec unicorn`


## Example Configuration

```yaml
session:
  # secret key for cookie store
  secret: <%= ENV["SESSION_SECRET"] %>


# array of oauth settings
oauth:
    # oauth provider name (github/github/facebook/twitter)
  - provider:      github
    # your app id for the service
    client_id:     <%= ENV["GITHUB_CLIENT_ID"] %>
    # your app secret for the service
    client_secret: <%= ENV["GITHUB_CLIENT_SECRET"] %>
    # restrict user request (optional) 
#    restrictions:
        # use all
#      - type:  uid
#        value: 1234567890
#        role:  admin
        # use github only
#      - type:  name
#        value: arukoh
#        role:  admin
        # use github only
#      - type:  organization
#        value: org
#        role:  user
        # use google and facebook only
#      - type:  email
#        value: test@example.com
#        role:  user

role:
  admin: <%= ENV["ADMIN_PASSWORD"] %>
  user:  <%= ENV["USER_PASSWORD"] %>

# proxy definitions
proxy:
  - path: <%= /^\/(.*)/ %>
    dest: 'http://localhost:4567/$1'
  - host: localhost:8080
    path: <%= /^\/(.*)/ %>
    dest: 'http://localhost:4567/foo/$1'
```


## Thanks

OMonban is same concept with [google_auth_proxy](https://github.com/bitly/google_auth_proxy), [gate](https://github.com/typester/gate), etc.  

(c) 2015 arukoh. This code is distributed under the MIT license.
