require "spec_helper"

def create_posts(n)
  n.times do |i|
    Post.create(title: "Post #{i + 1}", description: "This is my description")
  end
end

def create_comments(n, post_id)
  n.times do |_i|
    Comment.create(name: "Femi", message: "My comment", post_id: post_id)
  end
end

describe "Posts" do
  before(:each) do
    Post.destroy_all
    Comment.destroy_all
  end

  describe "#comments" do
    context "when post has no associated comment" do
      it "return count of zero for comments" do
        create_posts(1)
        post = Post.first
        
        comments = post.comments

        expect(comments.size).to eq 0
      end
    end
  end

  describe "#comments" do
    context "when post has 2 associated comment" do
      it "return count of 2 for comments" do
        create_posts(1)
        post = Post.first
        create_comments(2, post.id)

        comments = post.comments

        expect(comments.size).to eq 2
        comments.each do |comment|
          expect(comment.post_id).to eq post.id
        end
      end
    end
  end
end
