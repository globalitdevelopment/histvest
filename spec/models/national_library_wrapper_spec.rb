# Encoding: UTF-8
require 'spec_helper'

describe NationalLibraryWrapper, :type => :model do
	describe ".search" do

		nlw = NationalLibraryWrapper.new("svend foyn")
		before { @result = nlw.search }

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

		before { @ref = NationalLibraryWrapper::new_reference_from("http://urn.nb.no/URN:NBN:no-nb_digibok_2009031003030") }

		subject { @ref }

		it "should be a reference" do
			expect(@ref).to be_an_instance_of(Reference)
		end

		it "should have correct info" do
			expect(@ref.title).to eq("Svend Foyn : et mindeskrift")
			expect(@ref.creator).to eq("Klæboe, Hans B.")
			expect(@ref.lang).to eq("und")
			expect(@ref.year).to eq(1895) 
		end
	end
end
