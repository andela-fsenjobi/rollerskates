class ListsController < Rollerskates::BaseController
  def new
    @list = List.new
  end

  def create
    list_params = params["lists"]
    @list = List.new
    @list.title = list_params["title"]
    @list.description = list_params["description"]
    @list.save
    redirect_to "/lists", status: 302
  end

  def index
    @lists = List.all
  end

  def edit
    @list = List.find(params["id"])
  end

  def update
    @list = List.find(params["id"])
    @list.title = params["lists"]["title"]
    @list.description = params["lists"]["description"]
    @list.save
    redirect_to "/lists", status: 302
  end

  def destroy
    @list = List.find(params["id"])
    @list.destroy
    redirect_to "/lists", status: 302
  end

  # private
  #
  #   def list_params
  #     params.require(:list).permit(:id, :title, :body)
  #   end
end
