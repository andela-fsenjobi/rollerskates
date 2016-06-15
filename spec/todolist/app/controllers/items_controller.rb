class ItemsController < Rollerskates::BaseController
  def new
    @item = Item.new
  end

  def create
    item_params = params["items"]
    @item = Item.new(name: item_params["name"], status: item_params["status"])
    @item.save
    redirect_to "/items", status: 302
  end

  def index
    @items = Item.all
  end

  def edit
    @item = Item.find(params["id"])
  end

  def update
    @item = Item.find(params["id"])
    @item.update(
      name: params["items"]["name"],
      status: params["items"]["status"]
    )
    @item.save
    redirect_to "/items", status: 302
  end

  def destroy
    @item = Item.find(params["id"])
    @item.destroy
    redirect_to "/items", status: 302
  end
end
