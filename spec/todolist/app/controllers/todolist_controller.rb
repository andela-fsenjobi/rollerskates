class TodolistController < Rollerskates::BaseController
  def about
    render :about, name: "Femi"
  end

  def index
    "['Write a book', 'Build a house', 'Get married', 'Buy a car']"
  end

  def show
    'Write a book'
  end

  def create
    'Post go swimming'
  end

  def edit
    'Put Write a book'
  end

  def update
    'Put Write a book'
  end

  def destroy
    'Delete Write a book'
  end
end
