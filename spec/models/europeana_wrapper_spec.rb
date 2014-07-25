# Encoding: UTF-8
require 'spec_helper'

 describe EuropeanaWrapper, :type => :model do
 	describe ".search" do
 		ew = EuropeanaWrapper.new("svend foyn")
 		before { @result = ew.search(0) }
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
 		url = "http://www.europeana.eu/portal/record/2022609/3701E9A913A319B8B3154E5A5340F31DECBA883A.html?utm_source=api&utm_medium=api&utm_campaign=U4YHdx6jK"
 		before { @ref = EuropeanaWrapper::new_reference_from(url) }
 		subject { @ref }
 		it "should be a reference" do
 			expect(@ref).to be_an_instance_of(Reference)
 		end
 		it "should have correct info" do
 			expect(@ref.title).to eq("Vardås fort, et tysk kystfort på Nøtterøy")
 			expect(@ref.creator).to eq("Yngvar Halvorsen")
 			expect(@ref.lang).to eq("no")
 			expect(@ref.year).to eq(nil)
 			expect(@ref.reference_type_id).to eq(15)
 			expect(@ref.url).to eq(url)
 		end
 	end
 	describe ".new_reference_from with inconsistent api" do
 		url = "http://www.europeana.eu/portal/record/2021002/e_IsShownAt_3287D67D_6018_40F1_B5E6_09BBD5F331ED.html?start=1&query=title%3ALucifer+%28P%C3%A4iv%C3%A4%29&startPage=1&rows=24"
 		before { @ref = EuropeanaWrapper::new_reference_from(url) }
 		subject { @ref }
 		it "should be a reference" do
 			expect(@ref).to be_an_instance_of(Reference)
 		end
 		it "should have correct info" do
 			expect(@ref.title).to eq("Lucifer (Päivä)")
 			expect(@ref.creator).to eq("Volpato, Giovanni (taiteilija)")
 			expect(@ref.lang).to eq("fi")
 			expect(@ref.year).to eq(nil)
 			expect(@ref.reference_type_id).to eq(15)
 			expect(@ref.url).to eq(url)
 		end
 	end
 end
