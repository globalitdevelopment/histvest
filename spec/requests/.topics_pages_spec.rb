# encoding: utf-8
require 'spec_helper'

describe "Topic pages", :type => :request do

  subject { page }

  describe "new topic" do

    let(:user) { FactoryGirl.create(:user) }
    
    before do
      sign_in user
      visit '/topics/new'
    end

    describe "has subheadings", :js => true do
      it { is_expected.to have_content("Steder") }
      it { is_expected.to have_content("Referanser") }
    end

    describe "can fill in forms" do
      before do
        fill_in "topic-title", with: "sample title"
        fill_in "topic-content", with: "sample content"
      end

      it "should create a topic" do
        expect { click_button "Lagre" }.to change(Topic, :count).by(1)
      end
    end

    describe "can add locations", :js => true do
      before do
        fill_in "add-location-input", with: "Oslo, Norway"
        click_link "add-location"
      end

      it { is_expected.to have_content "Oslo, Norway" }
    end

    describe "can remove locations", :js => true do
      before do
        fill_in "add-location-input", with: "Oslo, Norway"
        click_link "add-location"
        fill_in "add-location-input", with: "Bergen, Norway"
        click_link "add-location"
        click_link "c7" # ID of remove button for oslo, c7 refers to the client id of the oslo model in backbone.js
      end

      it { is_expected.not_to have_content "Oslo, Norway" }
    end

    describe "can search references", :js => true do
      before do
        fill_in "reference-search", with: "svend foyn"
        click_button "Søk"
        sleep 2
      end

      it { is_expected.to have_content "et mindeskrift" }
    end

    describe "can add references", :js => true do
      before do
        fill_in "reference-search", with: "svend foyn"
        click_button "Søk"
        sleep 2
        click_link "c17" # ID of add button for Svend Foyn : et mindeskrfit, c17 refers to the client id of the reference model in backbonejs
      end

      it { is_expected.to have_css "#reference-list-container>li>button#c17" }
    end
  end

end