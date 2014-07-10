class Ability
	include CanCan::Ability

	def initialize(user)
		user ||= User.new #guest user

		case user.role
			when 'admin'
				can :manage, :all
			when 'trusted_contributor'        
				can :manage, Topic        
				can :verify, Topic
				can :read, Article
				can :create, Article
				can :read, User
				can :update, User, :id => user.id
				cannot [:index], User      
			when 'contributor'
				can :create, Topic, :user_id => user.id
				can :update, Topic, :user_id => user.id
				can :read, Topic, :user_id => user.id
				can :read, User
				can :update, User, :id => user.id
				cannot [:index], User
			else
				can :read, Article
				can :read, Topic        
		end    
	end
end
