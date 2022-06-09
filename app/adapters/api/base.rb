# frozen_string_literal: true

module Api
  class Base
    include Singleton

    protected

    def base_url_with_scheme
      raise NotImplementedError, "#{self.class} has not implemented method '#{__method__}'"
    end

    def get(path: nil, headers: {}, query: {})
      invoke(method: 'get', path: path, headers: headers, query: query)
    end

    def post(path: nil, headers: {}, body: {})
      invoke(method: 'post', path: path, headers: headers, body: body)
    end

    def patch(path: nil, headers: {}, body: {})
      invoke(method: 'patch', path: path, headers: headers, body: body)
    end

    def invoke(method: nil, path: nil, headers: {}, body: {}, query: {})
      HTTParty.public_send(method, URI.join(base_url_with_scheme, path), headers: headers, body: body.to_json,
                                                                         query: query)
    end
  end
end
