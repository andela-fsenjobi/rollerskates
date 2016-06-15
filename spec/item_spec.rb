require "spec_helper"

def create_items(n)
  n.times do |i|
    Item.create(name: "Femi_#{i + 1}", status: "Done")
  end
end

describe "Items" do
  before(:each) do
    Item.destroy_all
  end

  describe ".all" do
    it "returns all records in the table" do
      create_items(5)
      expect(Item.all.length).to eq 5
    end
  end

  describe "#save" do
    it "persists the specified object" do
      item = Item.new(name: "Femi Senjobi", status: "Done")
      item.save

      expect(Item.last.name).to eq "Femi Senjobi"
      expect(Item.last.status).to eq "Done"
    end
  end

  describe "#destroy" do
    it "removes the object with corresponding key from the table" do
      create_items(2)
      item = Item.last
      item.destroy

      expect(Item.count).to eq 1
    end
  end

  describe "#update" do
    it "updates a row with new values" do
      create_items(1)
      first_item = Item.first
      first_item.update(name: "Femi Edited", status: "Edited")
      first_item.save

      expect(Item.first.name).to eq "Femi Edited"
      expect(Item.first.status).to eq "Edited"
    end

    describe ".first" do
      it "returns the first row in a table" do
        create_items(1)

        expect(Item.first.name).to eq "Femi_1"
        expect(Item.first.status).to eq "Done"
      end
    end

    describe ".last" do
      it "returns the last row in a table" do
        create_items(2)

        expect(Item.last.name).to eq "Femi_2"
        expect(Item.last.status).to eq "Done"
      end
    end

    describe ".find" do
      it "get the first row in a table" do
        create_items(1)
        item = Item.first
        searched_item = Item.find(item.id)

        expect(searched_item.id).to eq item.id
        expect(searched_item.name).to eq item.name
        expect(searched_item.status).to eq item.status
      end
    end

    describe ".destroy_all" do
      it "destroys all the rows in the table" do
        create_items(10)
        Item.destroy_all

        expect(Item.count).to eq 0
      end
    end
  end
end
