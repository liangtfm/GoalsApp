require 'spec_helper'

feature "the signup process" do

  it "has a new user page" do
    visit new_user_url
    expect(page).to have_content "Sign Up"
  end

  it "displays an error if password too short" do
    visit new_user_url
    fill_in('Username', with: 'bob')
    fill_in('Password', with: '123')
    click_button('Sign Up')
    expect(page).to have_content "Password is too short"
  end

  feature "signing up a user" do

    it "shows username on the homepage after signup" do
      visit new_user_url
      fill_in('Username', with: 'bob')
      fill_in('Password', with: '123456')
      click_button('Sign Up')
      expect(page).to have_content "bob"

    end

  end

end

feature "logging in" do

  it "shows username on the homepage after login" do
    FactoryGirl.create(:user)
    visit new_session_url
    fill_in('Username', with: 'bob')
    fill_in('Password', with: '123456')
    click_button('Sign In')
    expect(page).to have_content "bob"
  end

end

feature "logging out" do

  it "begins with logged out state" do
    visit goals_url
    expect(page).to_not have_content "bob"
  end

  it "doesn't show username on the homepage after logout" do
    FactoryGirl.create(:user)
    visit new_session_url
    fill_in('Username', with: 'bob')
    fill_in('Password', with: '123456')
    click_button('Sign In')
    click_button('Sign Out')
    expect(page).to_not have_content "bob"
  end

end