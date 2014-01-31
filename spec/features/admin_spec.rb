require "spec_helper"

feature "admin users" do
  feature "mess with goals" do
    it "should see other users' private goals" do
      log_in('bob')
      create_goal('build a table', false)
      click_button('Sign Out')

      log_in_admin
      click_link('Admin Interface')
      click_link('bob')
      expect(page).to have_content('build a table')
    end

    it "should be able to modify other people's goals" do
      log_in('bob')
      create_goal('build a table', false)
      click_button('Sign Out')

      log_in_admin
      click_link('Admin Interface')
      click_link('bob')

      click_link('Edit Goal')
      fill_in('name', with: 'better name')
      click_on('Update Goal')
      expect(page).to have_content('better name')
    end

    it "should be able to delete other users' goals" do
      log_in('bob')
      create_goal('build a table', false)
      click_button('Sign Out')

      log_in_admin
      click_link('Admin Interface')
      click_link('bob')

      click_on('Delete Goal')
      expect(page).to_not have_content('build a table')
    end
  end

  feature "mess with users" do
    it "should see list of users" do
      log_in('bob')
      create_goal('build a table', false)
      click_button('Sign Out')

      log_in_admin
      click_link('Admin Interface')
      expect(page).to have_content('bob')
    end

    it "should be able to delete users" do
      log_in('bob')
      create_goal('build a table', false)
      click_button('Sign Out')

      log_in_admin
      click_link('Admin Interface')
      click_on('bob')
      click_on('Delete User')
      expect(page).to_not have_content('bob')
    end
  end
end