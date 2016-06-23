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
      it "return count of zero for comments" do
        create_posts(1)
        post = Post.first
        create_comments(2, post.id)
        comments = post.comments

        expect(comments.size).to eq 2
        expect(comments.first).to be_a Comment
        expect(comments.first.post_id).to eq post.id
      end
    end
  end
end

describe "Comment" do
  before(:each) do
    Post.destroy_all
    Comment.destroy_all
  end

  describe "#post" do
    context "when comment is associated to a post" do
      it "return the parent post" do
        create_posts(1)
        post = Post.first
        create_comments(1, post.id)
        comment = Comment.first

        expect(comment.post).to be_a Post
        expect(comment.post_id).to eq post.id
        expect(comment.post.title).to eq post.title
      end
    end
  end
end
