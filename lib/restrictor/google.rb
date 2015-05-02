module Restrictor
  class Google

    def initialize(restrictions)
      @uids   = restrictions.select{|res| res["type"] == "uid"}
      @emails = restrictions.select{|res| res["type"] == "email"}
    end

    def exec(auth_hash)
      @uids.each do |res|
        return res["role"] if res["value"].to_s == auth_hash.uid
      end
      @emails.each do |res|
        return res["role"] if res["value"] == auth_hash.info.email
      end
      nil
    end
  end
end
