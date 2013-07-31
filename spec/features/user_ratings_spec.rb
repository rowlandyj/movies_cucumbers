require 'spec_helper'

describe "User ratings integration tests", :js => true do 

  let!(:user) { FactoryGirl.create(:user)  }
  let!(:collab_user) { FactoryGirl.build(:collab_user)  }

  before(:each) do
    login(user)
  end

  it "user can see their ratings page" do 
    visit user_ratings_path
    debugger
    element = find('a.selected')
    element[:href].ends_with?("/users/ratings").should be_true
  end

  # it "user can vist 'Rate Movies' page and rate a movie 5 stars" do
  #   visit user_ratings_path
  #   title = page.find('.title')
  #   expect(page).to have_text
  # end
end
