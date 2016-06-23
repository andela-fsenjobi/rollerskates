class CommentsController < Rollerskates::BaseController
  def create
    comment_params = params["comments"]
    @comment = Comment.new(
      name: comment_params["name"],
      message: comment_params["message"],
      post_id: comment_params["post_id"]
    )
    @comment.save
    redirect_to "/posts/#{@comment.post_id}", status: 302
  end

  def destroy
    @comment = Comment.find(params["id"])
    @comment.destroy
    redirect_to "/posts/#{@comment.post_id}", status: 302
  end
end
