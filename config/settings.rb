class Settings < Settingslogic
  source ENV["CONFIG_FILE"]
end

# check session
Settings["session"] = {} unless Settings["session"]
unless Settings.session["secret"]
  puts "Warning: ${SESSION_SECRET} is empty. not secure"
  Settings.session["secret"] = "this is session secret"
end
Settings.session.secret

# check oauth
def check_oauth(h)
  raise "Invalid oauth settings" unless h && h.provider && h.client_id && h.client_secret
  case h.provider.downcase.to_sym
  when :github
    h["name"]     = "GitHub"
    h["omniauth"] = "github"
    h["scope"]    = ["read:org"]
  when :google
    h["name"]     = "Google"
    h["omniauth"] = "google_oauth2"
    h["scope"]    = nil
  when :facebook
    h["name"]     = "Facebook"
    h["omniauth"] = "facebook"
    h["scope"]    = "email"
  when :twitter
    h["name"]     = "Twitter"
    h["omniauth"] = "twitter"
    h["scope"]    = nil
  else raise "#{h.provider} not support"
  end

  # check restrictions and role
  (h["restrictions"] || []).map{|r| r["role"] }.compact.uniq.each do |role|
    password = Settings.role.send(role)
    Settings.role[role] = "" unless password
  end
end
case Settings.oauth
when Hash
  check_oauth(Settings.oauth)
  Settings["oauth"] = [Settings.oauth]
when Array
  Settings.oauth.each{|h| check_oauth(h) }
else
  check_oauth(nil)
end

# check proxy
unless Settings.proxy && Settings.proxy.first.path && Settings.proxy.first.dest
  raise "Invalid proxy settings"
end
