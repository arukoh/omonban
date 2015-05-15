module Restrictor
  class GitHub

    def initialize(restrictions)
      @uids  = restrictions.select{|res| res["type"] == "uid"}
      @names = restrictions.select{|res| res["type"] == "name"}
      @orgs  = restrictions.select{|res| res["type"] == "organization"}
    end

    def exec(auth_hash)
      @uids.each do |res|
        return res["role"] || true if res["value"].to_s == auth_hash.uid
      end
      @names.each do |res|
        return res["role"] || true if res["value"].to_s == auth_hash.info.name
      end
      unless @orgs.empty?
        client = Octokit::Client.new(access_token: auth_hash.credentials.token)
        @orgs.each do |res|
          orgs = client.organizations.map(&:login)
          return res["role"] || true if orgs.include?(res["value"].to_s)
        end
      end
      nil
    end
  end
end
