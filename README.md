# Rollerskates [![Code Climate](https://codeclimate.com/github/andela-fsenjobi/rollerskates/badges/gpa.svg)](https://codeclimate.com/github/andela-fsenjobi/rollerskates) [![Build Status](https://semaphoreci.com/api/v1/femisenjobi/rollerskates/branches/master/badge.svg)](https://semaphoreci.com/femisenjobi/rollerskates) [![Coverage Status](https://coveralls.io/repos/github/andela-fsenjobi/rollerskates/badge.svg?branch=master)](https://coveralls.io/github/andela-fsenjobi/rollerskates?branch=master)

You all have heard about rails, right? (obviously). Rails is a gigantic framework capable of supporting massive projects. Like its name, it can support massive trains (trains) with tons of weight (requirements). Here is rollerskates, a micro MVC built with ruby and is just capable of getting you from here to there.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rollerskates'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rollerskates

## Usage

### Setup
Ensure that your folder structure follow this pattern:

```
app_name
│   
└───app
|   └───assets
|   └───controllers
|   └───models
|   └───views
└───config
|    └─── routes.rb
|    └───application.rb
└───db
|    └───app.db
└───config.ru
```

### Application.rb
Set up your application this way:

```ruby
require 'rollerskates'

module Todolist
	class Application < Rollerskates::Application
	end
end
```
Allow your application class to inherit form `Rollerskates::Application` class

### Config.ru
Set up your routes this way:

```ruby
APP_ROOT = __dir__
require_relative "./config/application.rb"
TodoApplication = Todolist::Application.new
use Rack::Reloader, 0
use Rack::MethodOverride
require_relative "./config/routes.rb"
use Rack::Static, urls: ["/css", "/js", "/fonts"], root: "/app/assets"
run TodoApplication
```

### Routes

```ruby
TodoApplication.pot.prepare do
  get "/", to: "welcome#index"
  resources :lists
  resources :items, only: :index
end

```
`resources` can also accomodate the only option.

### Controllers

```ruby
class ItemsController < Rollerskates::BaseController
  def index
    @items = Item.all
  end

  def new
  end

  def show
    @item = Item.find(params["id"])
    render :show_full
  end
end

```
Just like rails, controller action can take optional `render`. If the view to render is not stated explicitly, Rollerskates will render a view with the corresponding contoller action name.

### Models

```ruby
class Item < Rollerskates::BaseRecord
  property :name, type: :text, nullable: false
  property :status, type: :boolean, nullable: false

  create_table
  belongs_to :user
  has_many :product
  
  def self.recent
    order("id DESC").limit(5)
  end
end
```
Rolletskates automatically adds the `id, created_at and updated_at` fields and thus need not to be specified in the model. Other properties, however should be specified as above.

You can make use of associations with the rollerskates framework. Also, you can chain methods to a degree. Rollerskates ORM can accommodate chaining such as:
> `select(:prop1, :prop2, :prop3)`
> 
> `where(prop2: "Value")`
> 
> `order("prop DESC")`
> 
> `limit(5)`

And combinations such as:
> `select(:id, :name).where(status: "active").limit(5)`

NB: Unlike Rails, `Rollerskates` uses sigular expression for both `has_many` and `belongs_to`

### Views

```
│   
└───views
|   └───items
|       |____ new.erb
|       |____ show.erb
|───────layouts
|       |____ application.erb

```
Files in the view folder should be organized according to the controller and action name. Instance variables declared in the respective controller action are available to your view.

The views make use of a layouts. You can abstract common elements in all your views to the `views/layouts/application.erb` file.
## Testing

The tests could be run automatically by using

```bash
$ rspec
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/andela-fsenjobi/rollerskates. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).
