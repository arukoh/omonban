module Restrictor
  class Twitter

    def initialize(restrictions)
      @uids = restrictions.select{|res| res["type"] == "uid"}
    end

    def exec(auth_hash)
      @uids.each do |res|
        return res["role"] if res["value"].to_s == auth_hash.uid
      end
      nil
    end
  end
end
