require 'nokogiri'
require 'uri'

class Person < ActiveRecord::Base

	belongs_to :location

	def url
		"http://digitalarkivet.arkivverket.no/ft/person/#{pfid}"
	end

	def self.search(page = 1)
		vestfold = [ '0701','0702','0703','0704','0705','0706','0707',
			'0711','0712','0713','0714','0715','0716','0717','0718','0719',
			'0720','0721','0722','0723','0724','0725','0726','0727','0728',
			'0798']
		search_params = {
			page: page,
			k: vestfold.sample(5)
		}
		search_url = "http://digitalarkivet.arkivverket.no/ft/sok/1910?#{search_params.to_query}"
		puts search_url
		doc = Nokogiri::XML(WrapperHelper::fetch_http(search_url)) 
		doc.css("table.searchResultTable tbody tr").map do |tr|
			pfid = tr.css('td a')[0].attribute('href').value.scan(/pf\d+/).first
			next if Person.where(pfid: pfid).exists?

			person = self.new
			person.pfid = pfid
			person.name = tr.css('td')[0].text
			person.date_of_birth = tr.css('td')[1].text
			person.place_of_birth = tr.css('td')[2].text
			person.description = tr.css('td')[3].text
			person.location = Location.find_or_create_by! address: tr.css('td')[4].text

			person.save!
		end
	end

	def self.geocode_pending
		Location.where(id: self.pluck(:location_id).uniq).untagged.each do |location|
			puts "geocoding #{location.address}"
			location.geocode
			location.save
			sleep 1
		end
	end

end