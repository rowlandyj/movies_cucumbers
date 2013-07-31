require 'spec_helper'

describe "User search bar integration tests", :js => true do 

  let!(:user) { FactoryGirl.create(:user)  }
  let!(:collab_user) { FactoryGirl.build(:collab_user)  }

  before(:each) do
    login(user)
  end

  it "user can see the search bar on every page except 'Edit User' " do 
  end

  


end
