# == Schema Information
#
# Table name: reference_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime
#  updated_at  :datetime
#  typestrings :string(255)
#

require 'spec_helper'

describe ReferenceType, :type => :model do
	it { is_expected.to have_many(:references)}

	before { @reference_type = ReferenceType.new(
		name: "Example") 
	}

	subject { @reference_type }

	it { is_expected.to respond_to(:name) }

	it { is_expected.to be_valid }

	describe "when name is not present" do
		before { @reference_type.name = " " }
		it { is_expected.not_to be_valid }
	end

	describe "when name is too long" do
		before { @reference_type.name = "a" * 51 }
		it {is_expected.not_to be_valid }
	end
end
