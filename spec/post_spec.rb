require "spec_helper"

def create_posts(n)
  n.times do |i|
    Post.create(title: "Post #{i + 1}", description: "This is my description")
  end
end

describe "Posts" do
  before(:each) do
    Post.destroy_all
  end

  describe ".all" do
    it "returns all records in the table" do
      create_posts(2)
      expect(Post.all.length).to eq 2
    end
  end

  describe "#save" do
    it "persists the specified object" do
      post = Post.new(
        title: "Femi Senjobi",
        description: "This is my description"
      )
      post.save

      expect(Post.last.title).to eq "Femi Senjobi"
      expect(Post.last.description).to eq "This is my description"
    end
  end

  describe "#destroy" do
    it "removes the object with corresponding key from the table" do
      create_posts(2)
      post = Post.last
      post.destroy

      expect(Post.count).to eq 1
    end
  end

  describe "#update" do
    it "updates a row with new values" do
      create_posts(1)
      first_post = Post.first
      first_post.update(title: "Femi Edited", description: "Edited")
      first_post.save

      expect(Post.first.title).to eq "Femi Edited"
      expect(Post.first.description).to eq "Edited"
    end

    describe ".first" do
      it "returns the first row in a table" do
        create_posts(1)

        expect(Post.first.title).to eq "Post 1"
        expect(Post.first.description).to eq "This is my description"
      end
    end

    describe ".last" do
      it "returns the last row in a table" do
        create_posts(2)

        expect(Post.last.title).to eq "Post 2"
        expect(Post.last.description).to eq "This is my description"
      end
    end

    describe ".find" do
      it "get the first row in a table" do
        create_posts(1)
        post = Post.first
        searched_post = Post.find(post.id)

        expect(searched_post.id).to eq post.id
        expect(searched_post.title).to eq post.title
        expect(searched_post.description).to eq post.description
      end
    end

    describe ".destroy_all" do
      it "destroys all the rows in the table" do
        create_posts(10)
        Post.destroy_all

        expect(Post.count).to eq 0
      end
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
