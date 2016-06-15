APP_ROOT = __dir__
require APP_ROOT + "/config/application.rb"
TodoApplication = Todolist::Application.new
use Rack::MethodOverride
require APP_ROOT + "/config/routes.rb"
run TodoApplication
