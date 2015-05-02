require_relative "config/boot"
require_relative "lib/error"
require_relative "lib/oauth"
require_relative "lib/reverse_proxy"

class App < Sinatra::Base

  [self, OAuth::Handler].each do |klass|
    klass.configure do |app|
      app.set :root,     File.dirname(__FILE__)
      app.set :logging,  true
      app.set :sessions, secret: Settings.session["secret"]

      app.helpers Sinatra::ContentFor
      app.register Error::Handler
    end
  end

  use OAuth::Handler
  use ReverseProxy do
    reverse_proxy_options preserve_host: true, x_forwarded_host: true, matching: :all, replace_response_host: false
    Settings.proxy.each do |proxy|
      regist_reverse_proxy(proxy["host"], proxy["path"], proxy["dest"])
    end
  end
end