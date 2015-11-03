module OAuth
  module Helpers

    def authorized?
      session[:authorized]
    end

    def login!(user)
      session[:username]   = user.name
      session[:password]   = user.pass
      session[:authorized] = true
    end

    def logout!
      session.delete(:username)
      session.delete(:password)
      session.delete(:authorized)
    end

    def previous_url(value); session[:previous_url] = value; end
    def previous_url!; session.delete(:previous_url) || '/'; end

    def find_oauth(provider)
      settings.oauth.find{|h| h["omniauth"] == provider}
    end

    def auth_is_required?(host, path)
      proxy = Settings.proxy.find{|h| h["host"] == host && Regexp.new(h["path"]) =~ path}
      unless proxy
        proxy = Settings.proxy.find{|h| h["host"] == nil && Regexp.new(h["path"]) =~ path}.to_h
      end
      required = !proxy.has_key?("auth") || proxy["auth"]
      session[:authorized] = true unless required
      required
    end
  end
end
