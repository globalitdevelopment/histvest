# == Schema Information
#
# Table name: search_topics
#
#  id            :integer          not null, primary key
#  search_string :string(255)
#  view_count    :integer
#  created_at    :datetime
#  updated_at    :datetime
#

class SearchTopic < ActiveRecord::Base
	attr_accessible :search_string, :view_count

	def self.increment(search_string)
		search_topic = find_by_search_string(search_string)
		if search_topic
			search_topic.view_count += 1
			return search_topic.save
		else
			new_search_topic = self.new(search_string: search_string, view_count: 1)
			return new_search_topic.save
		end
	end
end
