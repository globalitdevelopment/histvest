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

require 'spec_helper'

describe User, :type => :model do
	it { is_expected.to have_many(:topics)}

	before { @user = User.new(name: "Example User", 
							  email: "user@example.com", 
							  password: "foobar", 
							  password_confirmation: "foobar",
							  role: 'admin') }

	subject { @user }

	it { is_expected.to respond_to(:name) }
	it { is_expected.to respond_to(:email) }
	it { is_expected.to respond_to(:password_digest) }
	it { is_expected.to respond_to(:password) }
	it { is_expected.to respond_to(:password_confirmation) }
	it { is_expected.to respond_to(:authenticate) }
	it { is_expected.to respond_to(:remember_token) }
	it { is_expected.to respond_to(:role) }

	it { is_expected.to be_valid }

	describe "when name is not present" do
		before { @user.name = " " }
		it { is_expected.not_to be_valid }
	end

	describe "when name is too long" do
		before { @user.name = "a" * 51 }
		it {is_expected.not_to be_valid }
	end

	describe "when email is not present" do
		before { @user.email = " " }
		it { is_expected.not_to be_valid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[user@foo,com user_at_foo.org example.user@foo. foo@bar_baz.com foo@bar+baz.com]

			addresses.each do |invalid_address|
				@user.email = invalid_address
				expect(@user).not_to be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
			addresses.each do |valid_address|
				@user.email = valid_address
				expect(@user).to be_valid
			end
		end      
	end

	describe "when email address is already taken" do
		before do
			user_with_same_email = @user.dup
			user_with_same_email.email = @user.email.upcase
			user_with_same_email.save
		end

		it { is_expected.not_to be_valid }
	end

	describe "when password not present" do 
		before { @user.password = @user.password_confirmation = " " }
		it { is_expected.not_to be_valid }
	end

	describe "when password doesn't match confirmation" do
		before { @user.password_confirmation = "mismatch" }
		it { is_expected.not_to be_valid }
	end

	describe "when password confirmation is nil" do
		before { @user.password_confirmation = nil }
		it { is_expected.not_to be_valid }
	end

	it { is_expected.to respond_to(:authenticate) }

	describe "return value of authenticate method" do
		before { @user.save }
		let(:found_user) { User.find_by_email(@user.email) }

		describe "with valid password" do
			it { is_expected.to eq(found_user.authenticate(@user.password)) }
		end

		describe "with invalid password" do 
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }

			it { is_expected.not_to eq(user_for_invalid_password) }
			specify { expect(user_for_invalid_password).to be_falsey }
		end
	end

	describe "with a password that is too short" do
		before { @user.password = @user.password_confirmation = "a" * 5 }
		it { is_expected.not_to be_valid }
	end

	describe "remember token" do
		before { @user.save }

		describe '#remember_token' do
		  subject { super().remember_token }
		  it { is_expected.not_to be_blank }
		end
	end
end
