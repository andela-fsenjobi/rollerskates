require "spec_helper"

describe "BaseModel" do
  describe ".table_name" do
    it "returns plural form of class, downcased and converted to a string" do
      expect(Item.table_name).to eq "items"
    end
  end

  describe ".model_name" do
    it "returns class of the" do
      expect(Item.model_name).to eq Item
    end
  end

  describe ".all_columns" do
    it "removes the object with corresponding key from the table" do
      columns = [:id, :created_at, :updated_at, :name, :status]
      expect(Item.all_columns).to eq columns
    end
  end
end
