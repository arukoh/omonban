Dir.glob(File.expand_path("../restrictor/*.rb", __FILE__)).each{|f| require f}

module Restrictor
  module Helpers

    def restrict(oauth, auth_hash)
      return restricted_user(nil) unless oauth["restrictions"]

      klass = Restrictor.const_get(oauth.name)
      name = klass.new(oauth.restrictions).exec(auth_hash)
      return nil unless name
      restricted_user(name)
    end

    private
    def restricted_user(name)
      RestrictedUser.new(name, name ? settings.role[name] : nil).freeze
    end

    class RestrictedUser < Struct.new(:name, :pass); end
  end
end
