require "coveralls"
Coveralls.wear!

$LOAD_PATH.unshift File.expand_path("../../lib", __FILE__)
require "todolist/config/application"
require "rspec"

RSpec.shared_context type: :feature do
  require "capybara/rspec"
  before(:all) do
    app = Rack::Builder.
          parse_file(File.join(__dir__, "todolist", "config.ru")).first
    Capybara.app = app
  end
end

ENV["RACK_ENV"] = "test"

def create_items(n)
  n.times do |i|
    Item.create(name: "Femi_#{i + 1}", status: "Done")
  end
end

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
