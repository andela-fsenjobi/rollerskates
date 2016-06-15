class List < Rollerskates::BaseModel
  property :title, type: :text, nullable: false
  property :description, type: :text, nullable: false
  create_table
end
