require 'spec_helper'

describe DigitalArchiveWrapper, :type => :model do
 	describe ".search" do
 		ew = DigitalArchiveWrapper.new("svend foyn")
 		before { @result = ew.search(0) }
 		subject { @result }
 		it "should return array" do
 			expect(@result).to be_an_instance_of(Array)
 		end
 		it "should fetch number of records" do
 			expect(ew.number_of_results).to be_a_kind_of(Integer)
 		end
 		it "should return array of References" do
 			@result.each do |r|
 				expect(r).to be_an_instance_of(Reference)
 			end
 		end
 	end
 	describe ".new_reference_from with inconsistent api" do
 		url = "http://digitalarkivet.arkivverket.no/ft/person/pf01038007000308"
 		before { @ref = DigitalArchiveWrapper::new_reference_from(url) }
 		subject { @ref }
 		it "should be a reference" do
 			expect(@ref).to be_an_instance_of(Reference)
 		end
 		it "should have correct info" do
 			expect(@ref.title).to eq("Svend Larsen")
 			expect(@ref.creator).to eq("Kraakstad Prgj.")
 			expect(@ref.lang).to eq("und")
 			expect(@ref.year).to eq(1822)
 			expect(@ref.reference_type_id).to eq(ReferenceType.find_by(name: "Person").id)
 			expect(@ref.url).to eq(url)
 		end
 	end
 end