# == Schema Information
#
# Table name: reference_sources
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe ReferenceSource, :type => :model do
	it { is_expected.to have_many(:references)}

	before { @reference_source = ReferenceSource.new(name: "Example") }

	subject { @reference_source }

	it { is_expected.to respond_to(:name) }

	it { is_expected.to be_valid }

	describe "when name is not present" do
		before { @reference_source.name = " " }
		it { is_expected.not_to be_valid }
	end

	describe "when name is too long" do
		before { @reference_source.name = "a" * 51 }
		it {is_expected.not_to be_valid }
	end

	describe ".search_all" do
		before { @result = ReferenceSource::search_all("svend") }

		subject { @result }

		it "should return array" do
			expect(@result).to be_an_instance_of(Array)
		end

		it "should return array of References" do
			@result.each do |r|
				expect(r).to be_an_instance_of(Reference)
			end
		end
	end
end
