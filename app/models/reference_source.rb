#ad == Schema Information
#
# Table name: reference_sources
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class ReferenceSource < ActiveRecord::Base
	has_many :references

	attr_accessible :name

	validates :name,
		presence: true, 
		length: { maximum: 50 },
		uniqueness: { case_sensitive: false }

	# Returns an array of References
	def self.search_all(query)
		WikipediaWrapper.new(query).search + NationalLibraryWrapper.new(query).search + EuropeanaWrapper.new(query).search + DigitalArchiveWrapper.new(query).search
	end

	# Returns new Refernce object based on url
	# This code is used by Reference when saving data. 
	def self.new_reference_from(url)
		determine_source(url)::new_reference_from(url)
	end

	def self.determine_source(url)
		if url.include? "http://no.wikipedia.org"
			return WikipediaWrapper
		elsif (url.include? "http://urn.nb.no" or url.include? "http://www.nb.no/")
			return NationalLibraryWrapper
		elsif url.include? "http://www.europeana.eu"
			return EuropeanaWrapper					
		elsif url.include? "http://digitalarkivet.arkivverket.no"
			return DigitalArchiveWrapper
		else
			return nil
		end
	end
end
