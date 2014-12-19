require 'nokogiri'
require 'uri'

class Person < ActiveRecord::Base

	belongs_to :location

	def url
		"http://digitalarkivet.arkivverket.no/ft/person/#{pfid}"
	end

	def self.search(page = 1)
		search_params = {
			page: page,
			k: ['0701']
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
			location.geocode
			location.save
		end
	end

end