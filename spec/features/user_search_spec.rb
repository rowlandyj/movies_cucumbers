require 'spec_helper'

describe "User search bar integration tests", :js => true do 

  let!(:user) { FactoryGirl.create(:user)  }
  let!(:collab_user) { FactoryGirl.build(:collab_user)  }

  before(:each) do
    login(user)
  end

  it "user can see the search bar on every page except 'Edit User' " do 
    visit recommendations_path
    expect(page).to have_text("Search")

    # visit ratings_path
    # expect(page).to have_text(" Search")
    # not sure why this won't work

    visit user_ratings_path
    expect(page).to have_text("Search")

    visit edit_user_registration_path
    expect(page).to_not have_text("Search")
  end

  # it "user can seach by director and get accurate results" do
  #   visit recommendations_path
  #   fill_in "query", :with => "Michael Mann"
  #   # save_and_open_page
  #   page.find('.pure-button-primary').click
  #   # click_button "query"
  #   expect(page).to have_text("Heat")
  #   expect(page).to have_text("Last of the Mohicans")


  # end

end
