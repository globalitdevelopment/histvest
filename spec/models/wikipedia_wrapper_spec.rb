# Encoding: UTF-8
require 'spec_helper'
require 'openssl'

describe WikipediaWrapper, :type => :model do
	describe ".search" do
		ww = WikipediaWrapper.new("svend foyn")
		before { @result = ww.search() }

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

	describe ".new_reference_from" do

		before { @ref = WikipediaWrapper::new_reference_from("http://no.wikipedia.org/wiki/Svend_Foyn") }

		subject { @ref }

		it "should be a reference" do
			expect(@ref).to be_an_instance_of(Reference)
		end

		it "should have correct info" do
			expect(@ref.title).to eq("Svend Foyn")
			expect(@ref.creator).to eq("Wikipedia")
			expect(@ref.lang).to eq("no")
			expect(@ref.year).to eq(nil)
		end
	end
end
