# == Schema Information
#
# Table name: reference_types
#
#  id          :integer          not null, primary key
#  name        :string(255)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  typestrings :string(255)
#

class ReferenceType < ActiveRecord::Base
	has_many :references

	attr_accessible :name, :typestrings

	serialize :typestrings, Array

	validates :name,
		presence: true, 
		length: { maximum: 50 },
		uniqueness: { case_sensitive: false }

	# The typestrings field holds aliases for types, used by third parties
	# This method allows us to save References without knowing the reference_type_id.
	# The aliases are set in the database seed
	# References with unknown types are set with reference_type_id nil
	def self.determine_type_id(reference_type_string)
		refs = ReferenceType.all.select { |m| m.typestrings.include? reference_type_string.downcase.strip }
		if refs.any?
			return refs.first.id
		else
			return ReferenceType.find_by(name: "Ukjent").id # unknown
		end
	end

	def self.determine_type_id_from_url(url)
		if ReferenceSource::determine_source(url) != nil
			ReferenceSource::determine_source(url)::determine_type_id_from_url(url)
		else
			return nil
		end
	end

	# this attribute will return icon name for reference type
	def icon
		"rt-#{self.name.downcase}-icon.png"
	end

end
