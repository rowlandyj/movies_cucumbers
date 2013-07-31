require 'spec_helper'

describe "User session integration tests", :js => true do 

  let!(:user) { FactoryGirl.create(:user)  }
  let(:collab_user) { FactoryGirl.build(:collab_user)  }

  # before(:each) do
  #   login(user)
  # end
  
  it "user can create a new account" do
    visit new_user_registration_path
    fill_in "Email", :with => collab_user.email
    fill_in "Password", :with => collab_user.password
    fill_in "Password confirmation", :with => collab_user.password_confirmation
    # save_and_open_page
    click_button "Sign up"
    expect(page).to have_text("Signed in successfully.")
    expect(page).to have_text("Recommendations")
  end

  it "user cannot create account if password is not confirmed" do 

  end

  it "User can login and start session" do 
    visit new_user_session_path
    expect(page).to have_text("Sign in")
    expect(page).to have_text("Email")
    expect(page).to have_text("Password")
    expect(page).to have_text("Sign up")
    fill_in "Email", :with => user.email
    fill_in "Password", :with => user.password
    click_button "Sign in"
    expect(page).to have_content 'Recommendations'
  end


  it "User can't start session with wrong password" do 
    visit new_user_session_path
    expect(page).to have_text("Sign in")
    expect(page).to have_text("Email")
    expect(page).to have_text("Password")
    expect(page).to have_text("Sign up")
    fill_in "Email", :with => user.email
    fill_in "Password", :with => 'fake-password'
    click_button "Sign in"
    expect(page).to have_content 'Invalid email or password.'
  end

  it "User can't begin session with wrong email" do 
    visit new_user_session_path
    expect(page).to have_text("Sign in")
    expect(page).to have_text("Email")
    expect(page).to have_text("Password")
    expect(page).to have_text("Sign up")
    fill_in "Email", :with => 'fake-email@fake.com'
    fill_in "Password", :with => 'fake-password'
    click_button "Sign in"
    expect(page).to have_content 'Invalid email or password.'
  end

  it "User can log out when they have an active session" do
    login(user)
    visit destroy_user_session_path
    expect(page).to have_text("Signed out successfully.")
  end

  it "User can update their email" do

  end

end

# scenario "User adds ingredient to cocktail" do
#   visit new_cocktail_path 

#   fill_in "Name", :with => "Flizzerlicious"
#   fill_in "Description", :with => "A shot of 151, A shot of Absinthe, 1 oz of real burning alcohol"
#   fill_in "Instructions", :with => "Light it up! Stir with ass out"
#   click_link "Add Ingredient"

#   expect(page).to have_text("Quantity")
#   expect(page).to have_text("Unit of measurement")
#   within('form.new_cocktail fieldset') do
#     fill_in "Name", :with => "Stuff"
#     fill_in "Quantity", :with => "2"
#     fill_in "Unit of measurement", :with => "1oz"
#   end
#   click_button "Create Cocktail"
#   expect(page).to have_text("Your cocktail")

# end
