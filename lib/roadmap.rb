require 'httparty'

module Roadmap
    include HTTParty
    base_uri "https://www.bloc.io/api/v1"

    def get_roadmap
        response = self.class.get("/roadmaps/#{@roadmap_id}", headers: {authorization: @auth_token})
        @checkpoint_id = (JSON.parse(response.body))["sections"][0]["checkpoints"][0]["id"]
        p @checkpoint_id
        @roadmap = JSON.parse(response.body, {:symbolize_names => true})
    end
    
    def get_checkpoint
        response = self.class.get("/checkpoints/#{@checkpoint_id}", headers: {authorization: @auth_token})
        @checkpoint = JSON.parse(response.body, {:symbolize_names => true})
    end
    
    def create_submission(checkpoint_id, assignment_branch, assignment_commit_link, comment)
        response = self.class.post("/checkpoint_submissions", 
                                    headers: {authorization: @auth_token}, 
                                    body: {
                                        checkpoint_id: checkpoint_id, 
                                        assignment_branch: assignment_branch, 
                                        assignment_commit_link: assignment_commit_link, 
                                        comment: comment,
                                        enrollment_id: @enrollment_id
                                    })
        @confirmed_submission = JSON.parse(response.body)
    end
end