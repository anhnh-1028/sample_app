module API
  module V1
    class Users < Grape::API
      include API::V1::Defaults

      prefix "api"
      version "v1", using: :path
      format :json

      before do
        authenticate_user!
      end

      resource :users do
        desc "Return all users"
        get "", root: :users do
          users = User.includes(:microposts)
          users_entities = API::Entities::User.represent users, except: [:microposts]
          response = respond_success users: users_entities
          present response
        end

        desc "Return a user"
        params do
          requires :id, type: String, desc: "ID of the user"
        end
        get ":id", root: "user" do
          user = User.find params[:id]
          users_entities = API::Entities::User.represent user, only: %i(name email microposts)
          response = respond_success user: users_entities
          present response
        end
      end
    end
  end
end
