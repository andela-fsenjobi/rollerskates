require "spec_helper"

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

        expect(comment.post_id).to eq post.id
        expect(comment.post.title).to eq post.title
      end
    end
  end
end
