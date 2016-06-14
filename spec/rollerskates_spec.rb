require 'spec_helper'

describe 'Todolist App' do
  include Rack::Test::Methods

  TodoApplication = Todolist::Application.new
  def app
    require "todolist/config/routes.rb"
    TodoApplication
  end
  #
  # it 'returns about page' do
  #   get "/todolist/about"
  #   expect(last_response).to be_ok
  #   expect(last_response.body).to eq("Hey Femi")
  # end

  it 'returns a list of all my todos' do
    get '/todolist'
    expect(last_response).to be_ok
    expect(last_response.body).to eq(
      "['Write a book', 'Build a house', 'Get married', 'Buy a car']"
    )
  end

  it 'returns first item in my todolist' do
    get '/todolist/1'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Write a book')
  end

  it 'can respond to post request' do
    post '/todolist'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Post go swimming')
  end

  it 'returns a list of all my todos' do
    get '/todolist'
    expect(last_response).to be_ok
    expect(last_response.body).to eq(
      "['Write a book', 'Build a house', 'Get married', 'Buy a car']"
    )
  end

  it 'can respond to put request' do
    put '/todolist/10'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Put Write a book')
  end

  it 'can respond to get request' do
    get '/todolist/10/edit'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Put Write a book')
  end

  it 'can respond to delete request' do
    delete '/todolist/12'
    expect(last_response).to be_ok
    expect(last_response.body).to eq('Delete Write a book')
  end
end

describe Rollerskates do
  it 'has a version number' do
    expect(Rollerskates::VERSION).not_to be nil
  end
end
