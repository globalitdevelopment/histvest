# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  password_digest :string(255)
#  created_at      :datetime
#  updated_at      :datetime
#  remember_token  :string(255)
#  role            :string(255)
#  status          :boolean
#  reset_token     :string(255)
#

class User < ActiveRecord::Base	
	extend Enumerize

	has_many :topics
	has_many :articles
	# magic password method
	has_secure_password
	
	#devise :confirmable

	attr_accessible :name, :email, :password, :password_confirmation, :role, :status
	attr_accessor :novalidate
	
	enumerize :role, in: [:admin, :contributor, :trusted_contributor], default: :contributor

	validates :name,
		presence: true, 
		length: { maximum: 50}

	VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
	validates :email, 
		presence: true, 
		format: { with: VALID_EMAIL_REGEX }, 
		uniqueness: { case_sensitive: false }

	validates :password, 
		presence: true, 
		length: { minimum: 6 },
		:unless => Proc.new { |u| u.persisted? and u.password.try(:strip)=='' or u.novalidate == true}

	validates :password_confirmation, 
		presence: true,
		:unless => Proc.new { |u| u.persisted? and u.password.try(:strip)=='' or u.novalidate == true}

	# downcase all emails to ensure uniqueness
	before_save { |user| user.email = email.downcase }
	before_save :create_remember_token

	def admin?
  	self.role == "admin"
  end


	private
	
		def create_remember_token
			self.remember_token = SecureRandom.urlsafe_base64
		end
end
