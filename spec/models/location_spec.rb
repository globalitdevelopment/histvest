# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  address    :string(255)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  latitude   :float
#  longitude  :float
#  gmaps      :boolean
#

require 'spec_helper'

describe Location, :type => :model do
  it { is_expected.to have_and_belong_to_many(:topics)}
end
