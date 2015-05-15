require_relative "oauth/helpers"
require_relative "restrictor"

module OAuth
  class Handler < Sinatra::Base

    set :oauth, Settings.oauth
    set :role,  Settings["role"]

    use OmniAuth::Builder do
      OAuth::Handler.oauth.each do |h|
        provider(h.omniauth, h.client_id, h.client_secret, scope: h.scope)
      end
    end

    helpers Helpers, Restrictor::Helpers

    get '/auth/:provider/callback' do |provider|
      oauth = find_oauth(provider)
      halt 403, "#{request.path_info} is invalid path" unless oauth

      user = restrict(oauth, env['omniauth.auth'])
      login!(user) if user
      redirect to(user ? previous_url! : "/auth/failure")
    end

    get '/auth/failure' do
      halt 403, params["message"]
    end

    get '/logout' do
      logout!
      redirect to('/')
    end

    get '*' do
      if authorized?
        forward
      else
        previous_url(request.path_info)
        erb :login
      end
    end
  end
end
