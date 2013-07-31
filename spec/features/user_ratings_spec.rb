require 'spec_helper'

describe "User ratings integration tests", :js => true do 

  let!(:user) { FactoryGirl.create(:user)  }
  let!(:collab_user) { FactoryGirl.build(:collab_user)  }

  before(:each) do
    login(user)
  end

  it "user can see their ratings page" do 
    visit user_ratings_path
    expect(page).to have_text("Your Ratings")
  end


end
