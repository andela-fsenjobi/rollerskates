TodoApplication.routes.draw do
  resources "todolist"
  get "/todolist/:id/edit", to: "todolist#edit"
end
