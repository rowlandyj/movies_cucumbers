require 'spec_helper'

describe "User recommendations integration tests", :js => true do 

  it "user can see their recommendations page" do 
    visit recommendations_path
    expect(page).to have_text("Recommendations")
  end

end


