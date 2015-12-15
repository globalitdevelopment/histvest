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

require 'spec_helper'

describe Rejection, :type => :model do 

	it { is_expected.to belong_to :user }
	it { is_expected.to belong_to :topic }

	it { is_expected.to respond_to :reason }
	it { is_expected.to respond_to :unchanged }

	before { @rejection = Rejection.new	}

	describe "new rejection should be unchanged" do
		it { expect(@rejection.unchanged).to eq(true) }
	end

end
