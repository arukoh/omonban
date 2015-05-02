require_relative "oauth/helpers"
require_relative "restrictor"

module OAuth
  class Handler < Sinatra::Base

    set :oauth, Settings.oauth
    set :role,  Settings.role

    use OmniAuth::Builder do
      OAuth::Handler.oauth.each do |h|
        provider(h.omniauth, h.client_id, h.client_secret, scope: h.scope)
      end
    end

    helpers Helpers, Restrictor::Helpers

    before do
      pass if request.path_info =~ /^\/(login$|auth\/.+\/callback$|auth\/failure$)/
      unless authorized?
        previous_url(request.path_info)
        redirect to("/login")
      end
    end

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

    get '/login' do
      erb :login
    end

    get '/logout' do
      logout!
      redirect to('/login')
    end
  end
end
