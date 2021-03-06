require './lib/kele'
require 'httparty'
require './lib/roadmap'
require 'json'

class Kele
    include HTTParty
    include Roadmap
    base_uri "https://www.bloc.io/api/v1"

    def initialize(email, password)
        response = self.class.post("/sessions", body: {email: email, password: password})
        raise "Invalid email or password" if response.code == 404
        @auth_token = response['auth_token']
    end
    
    def get_me
        response = self.class.get("/users/me", headers: {authorization: @auth_token})
        @mentor_id = (JSON.parse(response.body))["current_enrollment"]["mentor_id"]
        @roadmap_id = (JSON.parse(response.body))["current_enrollment"]["roadmap_id"]
        @email = (JSON.parse(response.body))["email"]
        @enrollment_id = (JSON.parse(response.body))["current_enrollment"]["id"]
        p @enrollment_id
        @user_data = (JSON.parse(response.body, {:symbolize_names => true}))
    end
    
    def get_mentor_availability
        response = self.class.get("/mentors/#{@mentor_id}/student_availability", headers: {authorization: @auth_token})
        @mentor_availability = JSON.parse(response.body, {:symbolize_names => true})
    end
    
    def get_messages(page = 1)
        response = self.class.get("/message_threads?page=#{page}", headers: {authorization: @auth_token})
        @messages = JSON.parse(response.body, {:symbolize_names => true})
    end
    
    def create_message(recipient_id, subject, message)
        response = self.class.post("/messages", headers: {authorization: @auth_token}, body: {sender: @email, recipient_id: recipient_id, subject: subject, "stripped-text": message})
        puts response
    end
end