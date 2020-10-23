module API
  module Entities
    class User < Grape::Entity
      expose :id
      expose :name
      expose :email
      expose :created_at do |user|
        user.created_at.to_date
      end
      expose :microposts do |user|
        API::Entities::Micropost.represent user.microposts
      end
      expose :micropost_count do |user|
        user.microposts.size
      end
    end
  end
end
