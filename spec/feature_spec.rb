require "spec_helper"

describe "Items", type: :feature do
  before :all do
    Item.destroy_all
  end

  scenario "user supplies name and status" do
    visit "/items/new/"
    expect(page).to have_content "New Item"
    fill_in "item-name", with: "First Item"
    fill_in "item-status", with: "Done"
    click_button "item-submit"
    expect(page).to have_content "First Item"
  end

  scenario "user edits name and status" do
    visit "/items/"
    expect(page).to have_content "First Item"
    click_link "item-edit"
    expect(page.current_path).to end_with "/edit"
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
