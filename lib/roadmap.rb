require 'httparty'

module Roadmap
    include HTTParty
    base_uri "https://www.bloc.io/api/v1"

    def get_roadmap
        response = self.class.get("/roadmaps/#{@roadmap_id}", headers: {authorization: @auth_token})
        @checkpoint_id = (JSON.parse(response.body))["sections"][0]["checkpoints"][0]["id"]
        @roadmap = JSON.parse(response.body, {:symbolize_names => true})
        p @checkpoint_id
    end
    
    def get_checkpoint
        response = self.class.get("/checkpoints/#{@checkpoint_id}", headers: {authorization: @auth_token})
        @checkpoint = JSON.parse(response.body, {:symbolize_names => true})
    end
end