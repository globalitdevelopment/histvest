# Encoding: UTF-8
# == Schema Information
#
# Table name: references
#
#  id                  :integer          not null, primary key
#  title               :string(255)
#  creator             :string(255)
#  year                :integer
#  lang                :string(255)
#  snippet             :string(255)
#  url                 :string(255)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  reference_type_id   :integer
#  reference_source_id :integer
#  topic_id            :integer
#

require 'spec_helper'

describe Reference, :type => :model do

	before { @ref = Reference.new(
		title: "Svend Foyn - et mindeskrift", 
		creator: "Klæbo", 
		year: 1895, 
		lang: "und")
	}

	subject { @ref }

	it { is_expected.to belong_to(:reference_type) }
	it { is_expected.to belong_to(:reference_source) }
	it { is_expected.to belong_to(:topic) }

	it { is_expected.to respond_to(:title) }
	it { is_expected.to respond_to(:creator) }
	it { is_expected.to respond_to(:year) }
	it { is_expected.to respond_to(:lang) }
	it { is_expected.to respond_to(:snippet) }
	it { is_expected.to respond_to(:url) }

	it { is_expected.to be_valid }

	describe "it should be possible to create from URL" do
		before {
			@new_ref = Reference.new(url: "http://urn.nb.no/URN:NBN:no-nb_digibok_2009031003030")
			@new_ref.save
		}

		it "with correctly fetched data" do
			expect(@new_ref.title).to eq("Svend Foyn : et mindeskrift")
			expect(@new_ref.creator).to eq("Klæboe, Hans B.")
			expect(@new_ref.lang).to eq("und")
			expect(@new_ref.year).to eq(1895) 
		end
	end
end
