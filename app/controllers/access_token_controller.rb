class AccessTokenController < Doorkeeper::TokensController
  def create
    response = strategy.authorize
    response_body = response.body

    if response.status == :ok
      response_body[:owner_id] = response.token.resource_owner_id
      # response_body[:roles] = response.token.scopes

      if response.token.scopes.include?("manager")
        manager = Manager.find(response.token.resource_owner_id)
        # response_body[:roles] = manager.manager_roles.map do |manager_role|
        #   json = {"role" => manager_role.role.name}.as_json
        #   json["level"] = 0.in?(District.where(:id => manager_role.manager_role_objects.pluck(:object_id)).valid.flat_map{|s| s.level}) ? 'city' : 'section'
        #   json
        end
      end


    end

    self.headers.merge! response.headers
    self.response_body = response_body.to_json
    self.status        = response.status
  rescue Doorkeeper::Errors::DoorkeeperError => e
    handle_token_exception e
  end

end