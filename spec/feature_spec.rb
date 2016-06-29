require "spec_helper"

describe "Items", type: :feature do
  before :all do
    Item.destroy_all
  end

  scenario "user visits home page" do
    visit "/"
    expect(page).to have_content "Create New Item"
    expect(page).to have_content "All Items"
  end

  scenario "user clicks link to create new item" do
    visit "/"
    click_link "Create New Item"
    expect(page).to have_content "New Item"
  end

  scenario "user creates new item" do
    visit "/items/new/"
    fill_in "item-name", with: "First Item"
    fill_in "item-status", with: "Done"
    click_button "item-submit"
    expect(page).to have_content "First Item"
    expect(page.current_path).to eq "/items"
  end

  scenario "user clicks to edit item" do
    visit "/items/"
    click_link "item-edit"
    expect(page.current_path).to end_with "/edit"
  end

  scenario "user edits item name and status" do
    visit "/items/"
    click_link "item-edit"
    fill_in "item-name", with: "First Item Edited"
    fill_in "item-status", with: "Done"
    click_button "item-submit"
    expect(page.current_path).to eq "/items"
    expect(page).to have_content "First Item Edited"
  end

  scenario "user deletes an item" do
    visit "/items/"
    click_button "item-delete"
    expect(page.current_path).to eq "/items"
    expect(page).not_to have_content "First Item Edited"
  end
end
