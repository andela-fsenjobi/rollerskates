class Comment < Rollerskates::BaseModel
  property :name, type: :text, nullable: false
  property :message, type: :text, nullable: false
  property :post_id, type: :integer, nullable: false
  create_table

  belongs_to :post
end
