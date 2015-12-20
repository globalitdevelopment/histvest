# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  address    :string(255)
#  created_at :datetime
#  updated_at :datetime
#  latitude   :float
#  longitude  :float
#  gmaps      :boolean
#

# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  address    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  topic_id   :integer
#  latitude   :float
#  longitude  :float
#  gmaps      :boolean
#
require 'truncate_html'

class Location < ActiveRecord::Base
	attr_accessible :address, :latitude, :longitude, :topic_id

	has_and_belongs_to_many :topics

	has_many :people

	acts_as_gmappable :process_geocoding => false

	# search configuration

	include Elasticsearch::Model

  settings do 
  	mapping do
  		indexes :id, index: :not_analyzed
  		indexes :address, analyzer: :norwegian
  		indexes :point, type: :geo_point
  		indexes :people do
  			indexes :name
  			indexes :url
  		end 
  	end
  end

  def as_indexed_json opts={}
  	opts.merge!(
  		only: [:id, :address, :latitude, :longitude],
  		methods: [:point]
  	)
  	ret = as_json opts
  	ret[:people] = people.map do |p|
  		{name: p.name, url: Rails.application.routes.url_helpers.person_path(p.pfid)}
  	end
  	ret
  end

	def gmaps4rails_address
		"#{self.address} Norway"
	end

	scope :tagged, -> { where.not(latitude: nil) }
	scope :untagged, -> { where(latitude: nil) }

	geocoded_by :address

	def point
		{ lat: latitude, lon: longitude }
	end
	
end
