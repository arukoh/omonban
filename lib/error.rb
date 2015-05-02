module Error
  module Handler

    CODE_MESSAGE_MAPPING = Hash[[
      [400, "Bad Request"],
      [401, "Unauthorized"],
      [402, "Payment Required"],
      [403, "Forbidden"],
      [404, "Not Found"],
      [405, "Method Not Allowed"],
      [406, "Not Acceptable"],
      [407, "Proxy Authentication Required"],
      [408, "Request Timeout"],
      [409, "Conflict"],
      [410, "Gone"],
      [411, "Length Required"],
      [412, "Precondition Failed"],
      [413, "Request Entity Too Large"],
      [414, "Request-URI Too Long"],
      [415, "Unsupported Media Type"],
      [416, "Requested Range Not Satisfiable"],
      [417, "Expectation Failed"],
      [500, "Internal Server Error"],
      [501, "Not Implemented"],
      [502, "Bad Gateway"],
      [503, "Service Unavailable"],
      [504, "Gateway Timeout"],
      [505, "HTTP Version Not Supported"],
    ]]

    module Helpers
      def error_message(code, detail=nil)
        @detail  = detail.is_a?(Array) ? detail.join("\n") : detail.to_s
        @message = "#{code} #{CODE_MESSAGE_MAPPING[code] || "Unkwon"}"
      end
    end

    def self.registered(app)
      app.helpers Helpers

      app.error do |e|
        code = e.respond_to?(:code) ? e.code : 500
        error_message(500, e.message)
        erb :error
      end

      app.error 400..510 do
        error_message(response.status, response.body)
        erb :error
      end
    end
  end
end
