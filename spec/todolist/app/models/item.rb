class Item < Rollerskates::BaseModel
  property :name, type: :text, nullable: false
  property :status, type: :text, nullable: false
  create_table
end
