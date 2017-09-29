require 'httparty'
require 'json'
require './lib/kele'

class Kele
    include HTTParty

    def initialize(email, password)
        response = self.class.post(api_url("sessions"), body: {email: email, password: password})
        raise "Invalid email or password" if response.code == 404
        @auth_token = response['auth_token']
    end
    
    def get_me
        response = self.class.get(api_url("users/me"), headers: {authorization: @auth_token})
        @user_data = (JSON.parse(response.body)).to_h
    end
    
    private
    
    def api_url(end_point)
       "https://www.bloc.io/api/v1/#{end_point}"
    end

end