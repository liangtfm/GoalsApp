require "spec_helper"

feature "create goals" do
  it "should have a button on homepage to create goal" do
    log_in('bob')
    visit goals_url
    expect(page).to have_content("Set A New Goal")
  end

  it "should have a form for creating new goals" do
    log_in('bob')
    visit new_goal_url
    expect(page).to have_button("Set Goal")
  end
end

feature "view goals" do
  it "should display the user's goals on homepage" do
    log_in('bob')
    create_goal('build a table')
    visit goals_url
    expect(page).to have_content('build a table')
  end

  it "should display other users' public goals" do
    log_in('bob')
    create_goal('build a table')
    click_button('Sign Out')
    log_in('tom')
    visit goals_url
    expect(page).to have_content('build a table')
  end

  it "should not display other user's private goals" do
    log_in('bob')
    create_goal('build a table', false)
    click_button('Sign Out')
    log_in('tom')
    visit goals_url
    expect(page).to_not have_content('build a table')
  end

  it "should link goals to their show page" do
    log_in('bob')
    create_goal('build a table')
    visit goals_url
    click_link('Goal Details')
    expect(page).to have_link('Edit Goal')
  end
end

feature "editing goals" do

  it "should be able to update goals" do
    log_in('bob')
    create_goal('build a table')
    visit goals_url
    click_link('Goal Details')

    click_link('Edit Goal')
    fill_in('name', with: 'better goal')
    click_button('Update Goal')
    visit goals_url
    expect(page).to have_content('better goal')
  end

  it "should be able to delete goals" do
    log_in('bob')
    create_goal('build a table')
    visit goals_url
    click_link('Goal Details')

    click_link('Edit Goal')
    click_button('Delete Goal')

    visit goals_url
    expect(page).to_not have_content('build a table')
  end

  it "deleting goals should redirect to homepage" do
    log_in('bob')
    create_goal('build a table')
    visit goals_url
    click_link('Goal Details')

    click_link('Edit Goal')
    click_button('Delete Goal')

    expect(page).to have_content("Look at all these goals.")
  end
end

feature "completing goals" do

  it "should have button to complete goal on homepage" do
    log_in('bob')
    goal_id = create_goal('build a table')
    visit goals_url
    expect(page).to have_button('Complete Goal')
  end

  it "should have button to un-complete goal on goal edit page" do
    log_in('bob')
    goal_id = create_goal('build a table')
    visit goals_url
    click_button('Complete Goal')
    # click_button('complete_#{goal_id}')

    visit edit_goal_url(goal_id)
    uncheck('Completed')
    click_on('Update Goal')
    visit goals_url
    expect(page).to have_button('Complete Goal')
    # expect(page).to have_button('complete_#{goal_id}')
  end

  it "clicking button should complete the goal" do
    log_in('bob')
    goal_id = create_goal('build a table')
    visit goals_url
    click_button('Complete Goal')
    # click_button('complete_#{goal_id}')
    visit goals_url
    expect(page).to_not have_button('Complete Goal')
    # expect(page).to_not have_button('complete_#{goal_id}')
  end
end