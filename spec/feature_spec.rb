require "spec_helper"

describe "Items", type: :feature do
  before :all do
    Item.destroy_all
  end

  feature "user visits home page" do
    scenario " user sees all items" do
      visit "/"

      expect(page).to have_content "Create New Item"
      expect(page).to have_content "All Items"
    end
  end

  feature "user clicks link to create new item" do
    scenario " sees the create form" do
      visit "/"
      click_link "Create New Item"

      expect(page).to have_content "New Item"
    end
  end

  feature "user creates new item" do
    scenario " creates item and redirect to index page" do
      visit "/items/new/"
      fill_in "item-name", with: "First Item"
      fill_in "item-status", with: "Done"
      click_button "item-submit"

      expect(page).to have_content "First Item"
      expect(page.current_path).to eq "/items"
    end
  end

  feature "user clicks link to edit item" do
    scenario " loads page to edit item" do
      visit "/items/"
      click_link "item-edit"

      expect(page.current_path).to end_with "/edit"
    end
  end

  feature "user edits item name and status" do
    scenario " redirects to index and shows edited content" do
      visit "/items/"
      click_link "item-edit"
      fill_in "item-name", with: "First Item Edited"
      fill_in "item-status", with: "Done"
      click_button "item-submit"

      expect(page.current_path).to eq "/items"
      expect(page).to have_content "First Item Edited"
    end
  end

  feature "user deletes an item" do
    scenario " item is deleted from the list" do
      visit "/items/"
      click_button "item-delete"
      
      expect(page.current_path).to eq "/items"
      expect(page).not_to have_content "First Item Edited"
    end
  end
end
