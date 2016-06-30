require "spec_helper"

describe "BaseModel" do
  describe ".table_name" do
    it "returns plural form of class, downcased and converted to a string" do
      expect(Item.table_name).to eq "items"
    end
  end

  describe ".model_name" do
    it "returns model class converted to a string " do
      expect(Item.model_name).to eq "item"
    end
  end

  describe ".all_columns" do
    it "returns all the table columns" do
      columns = [:id, :created_at, :updated_at, :name, :status]
      expect(Item.all_columns).to eq columns
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
      it "deletes the object from the table" do
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
        it "get the row with specified id from a table" do
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

    describe "Posts" do
      before(:each) do
        Post.destroy_all
      end

      describe ".limit(5)" do
        it "returns the number of records specified" do
          create_posts(10)

          posts = Post.limit(5)

          expect(posts.length).to eq 5
        end
      end

      describe ".order('id DESC')" do
        it "returns the records in descending order" do
          create_posts(10)

          posts = Post.order("id DESC")

          expect(posts.first.title).to eq "Post 10"
        end
      end

      describe ".destroy(id)" do
        it "destroys the record with specified id" do
          create_posts(1)

          post = Post.first
          Post.destroy(post.id)
          
          expect(Post.count).to eq 0
        end
      end
    end
  end
end
