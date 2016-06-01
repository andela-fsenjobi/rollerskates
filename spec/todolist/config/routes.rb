TodoApplication.routes.draw do
  get "/todolist/:id/edit", to: "todolist#edit"
  get "/todolist/about", to: "todolist#about"
  get "/todolist/femi", to: "todolist#femi"
  resources "todolist"
end
