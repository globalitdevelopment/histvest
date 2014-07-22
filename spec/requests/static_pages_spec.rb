require 'spec_helper'

describe "StaticPages", :type => :request do
  let(:user) { FactoryGirl.create(:user) }
  before do 
      sign_in user
  end
  
  describe "Admin page" do

    it "should have the content 'Historiske Vestfold'" do
      visit '/static_pages/admin'
      expect(page).to have_content('Tema')
      expect(page).to have_content('Brukere')
      expect(page).to have_content('Nyheter')
    end
  end
end
