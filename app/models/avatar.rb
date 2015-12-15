# == Schema Information
#
# Table name: avatars
#
#  id                      :integer          not null, primary key
#  topic_id                :integer
#  created_at              :datetime
#  updated_at              :datetime
#  avatar_img_file_name    :string(255)
#  avatar_img_content_type :string(255)
#  avatar_img_file_size    :integer
#  avatar_img_updated_at   :datetime
#  article_id              :integer
#

class Avatar < ActiveRecord::Base
	attr_accessible :topic_id, :article_id, :avatar_img

	has_attached_file :avatar_img,:url => "/system/:attachment/:id/:style/:filename", :styles => { :infowindow => "200x200>", :medium => "300x300>", :thumb => "100x100>", :marker_mini => "50x50>" }
	validates_attachment_content_type :avatar_img, :content_type => /\Aimage\/.*\Z/
	belongs_to :topic
	belongs_to :article
end
