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

require 'spec_helper'

describe Article, :type => :model do
  it { is_expected.to belong_to(:user)}
end
