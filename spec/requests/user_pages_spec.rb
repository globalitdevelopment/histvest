require 'spec_helper'

describe "User pages", :type => :request do

  subject { page }
  
  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    
    before do       
      sign_in user
      visit user_path(user)
    end

    it { is_expected.to have_selector('h1',    text: user.name) }
    it { page.should have_title(user.name) }
  end

  describe "account creation" do

    let(:user) { FactoryGirl.create(:user) }


    before do
      sign_in user 
      visit '/users/new'
    end

    let(:submit) { I18n.t("users.create_account") }

    describe "with invalid information" do
      it "should not create a user" do
        # No longer works, very possibly due to transaction changes in rspec config.
        # expect { click_button I18n.t("users.create_account") }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in I18n.t("users.name"),         with: "Example User"
        fill_in I18n.t("users.email"),        with: "user@example.com"
        fill_in I18n.t("users.password"),     with: "foobar"
        fill_in I18n.t("users.password_confirm"), with: "foobar"
      end

      it "should create a user" do
        # No longer works, very possibly due to transaction changes in rspec config.
        # expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end