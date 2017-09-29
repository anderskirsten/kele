require 'httparty'
require './lib/kele'

class Kele
    include HTTParty

    def initialize(email, password)
        response = self.class.post((api_base_url + '/sessions'), body: {email: email, password: password})
        raise "Invalid email or password" if response.code == 404
        @auth_token = response['auth_token']
    end
    
    private
    
    def api_base_url
       'https://www.bloc.io/api/v1'
    end

end