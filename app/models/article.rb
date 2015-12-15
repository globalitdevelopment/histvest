# == Schema Information
#
# Table name: articles
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  title           :string(255)
#  content         :text
#  created_at      :datetime
#  updated_at      :datetime
#  published       :boolean
#  published_start :datetime
#  published_end   :datetime
#  article_type    :string(255)
#

class Article < ActiveRecord::Base
	belongs_to :user
	has_one :avatar, :dependent => :destroy
	attr_accessible :content, :title, :type, :user_id, :published, :published_start, :published_end
	validates :title,
		presence: true,
		length: { maximum: 100 }

	validates :content,
		presence: true

	def self.published
		where("
			published = true and (
				(published_start <= ? and published_end >= ?) or
				(published_end IS NULL and published_start IS NULL)
			)", Time.now, Time.now)
	end

	def published?
		# not published if only start or end date is defined
		if (!self.published_start.nil? && self.published_end.nil?) || (self.published_start.nil? && !self.published_end.nil?)
			return false
		end
		
		self.published == true &&
			(
				(self.published_start.nil? && self.published_end.nil?) ||
				(self.published_start <= Time.now && self.published_end >= Time.now)
			)
	end
end
