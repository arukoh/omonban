class ReverseProxy < Rack::ReverseProxy
  alias_method :_call_, :call

  def call(env)
    change_matchers(env["HTTP_HOST"]) do
      @global_options[:username] = env["rack.session"]["username"]
      @global_options[:password] = env["rack.session"]["password"]
      _call_(env)
    end
  ensure
    @global_options[:username] = @global_options[:password] = nil
  end

  private
  def regist_reverse_proxy(host, matcher, url=nil, opts={})
    change_matchers(host) do
      reverse_proxy(matcher, url, opts)
      @host_matchers_map[host] = @matchers
    end
  end

  def change_matchers(host=nil, &block)
    @host_matchers_map ||= {}
    @matchers = @host_matchers_map[host] || @host_matchers_map[nil] || []
    block.call
  ensure
    @matchers = @host_matchers_map[nil]
  end
end
