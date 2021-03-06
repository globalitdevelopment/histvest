# == Schema Information
#
# Table name: people
#
#  id             :integer          not null, primary key
#  location_id    :integer
#  pfid           :string(255)
#  name           :string(255)
#  date_of_birth  :string(255)
#  place_of_birth :string(255)
#  description    :string(255)
#

require 'nokogiri'
require 'uri'

class Person < ActiveRecord::Base

	belongs_to :location

	VESTFOLD = [ '0701','0702','0703','0704','0705','0706','0707',
		'0711','0712','0713','0714','0715','0716','0717','0718','0719',
		'0720','0721','0722','0723','0724','0725','0726','0727','0728',
		'0798']

	# search configuration

	include Elasticsearch::Model

  settings do 
  	mapping do
  		indexes :name, analyzer: :norwegian, boost: 10
      indexes :pfid, index: :not_analyzed
  		indexes :location do
  			indexes :address, analyzer: :norwegian
  		end
  	end
  end

  def as_indexed_json opts={}
  	opts.merge!(
  		only: [:name, :pfid],
  		include: {
  			location: { only: [:address] }
  		}
  	)
  	as_json opts
  end

	def permalink
		self.class.permalink(pfid)
	end

	def self.permalink(pfid)
		"http://digitalarkivet.arkivverket.no/ft/person/#{pfid}"
	end

	def self.find_from_census pfid
		person = find_by pfid: pfid
		person ||= new_person_from permalink(pfid)
		person
	end

	def self.new_person_from(url)
		doc = Nokogiri::XML WrapperHelper::fetch_http(url)

		pfid = get_text_with_label doc, "ID:"

		person = find_by(pfid: pfid)
		return person if person

		person = self.new
		person.pfid = pfid
		person.name = doc.css("h4")[0].text
		person.date_of_birth = get_text_with_label doc, "Fødselsdato:"
		person.place_of_birth = get_text_with_label doc, "Fødested:"
		person.description = get_text_with_label doc, "Familiestilling:"
		person.location = Location.find_or_create_by! address: doc.css("table.searchResultTable.bosted td")[1].text
		if person.location.latitude.nil?
			person.location.geocode
			person.location.save
		end
		person.save!

		person
	end

	def self.parse_name name
		parts = name.to_s.split ' '
		if parts.size > 1
			[parts[0], parts[1]]
		else
			[parts[0], parts[0]]
		end
	end

	def self.lookup(params = {})
		params[:page] ||= 1
		params[:k] ||= VESTFOLD

		search_url = "http://digitalarkivet.arkivverket.no/ft/sok/1910?#{params.to_query}"
		puts search_url
		doc = Nokogiri::XML(WrapperHelper::fetch_http(search_url))

		@@pagination_info = doc.css(".resultTablePage .comment.standalone").first.text
		doc.css("table.searchResultTable tbody tr").map do |tr|
			pfid = tr.css('td a')[0].attribute('href').value.scan(/pf\d+/).first
			person = Person.find_by(pfid: pfid)

			unless person
				person = self.new
				person.pfid = pfid
				person.name = tr.css('td')[0].text
				person.date_of_birth = tr.css('td')[1].text
				person.place_of_birth = tr.css('td')[2].text
				person.description = tr.css('td')[3].text
				person.location = Location.find_or_create_by! address: tr.css('td')[4].text				
				person.save!
			end

			person
		end
	end

	def self.pagination_info
		@@pagination_info
	end

	def self.total_records
		@@pagination_info.scan(/\d+/).last || 0
	end

	def self.geocode_pending
		Geocoder.configure(:always_raise => [Geocoder::OverQueryLimitError])
		Location.where(id: self.pluck(:location_id).uniq).untagged.find_each do |location|
			puts "geocoding #{location.address}"
			begin
				location.geocode
			rescue Geocoder::OverQueryLimitError
				pool = [:yandex, :google, :ovi, :esri]
				chosen_one = pool.sample
				puts "Using #{chosen_one} for geocoding"
				Geocoder.configure lookup: chosen_one
			end
			location.save
			sleep 1 # most of lookup service limit 1 request/second
		end
	end

private

	def self.get_text_with_label(parser, label)
		nodes = parser.css('table.infotable td')
		nodes.each { |td| return nodes[nodes.index(td)+1].text if td.text.strip == label.strip }
		""
	end

end
