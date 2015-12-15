# == Schema Information
#
# Table name: rejections
#
#  id         :integer          not null, primary key
#  topic_id   :integer
#  user_id    :integer
#  reason     :text
#  unchanged  :boolean          default(TRUE)
#  created_at :datetime
#  updated_at :datetime
#

class Rejection < ActiveRecord::Base

	belongs_to :user
	belongs_to :topic

end
