class PostsController < Rollerskates::BaseController
  def new
    @post = Post.new
  end

  def create
    post_params = params["posts"]
    @post = Post.new(title: post_params["title"],
                     description: post_params["description"])
    @post.save
    redirect_to "/posts", status: 302
  end

  def index
    @posts = Post.all
  end

  def edit
    @post = Post.find(params["id"])
  end

  def show
    @post = Post.find(params["id"])
  end

  def update
    @post = Post.find(params["id"])
    @post.update(title: params["posts"]["title"],
                 description: params["posts"]["description"])
    @post.save
    redirect_to "/posts", status: 302
  end

  def destroy
    @post = Post.find(params["id"])
    @post.destroy
    redirect_to "/posts", status: 302
  end
end
