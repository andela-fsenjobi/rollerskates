APP_ROOT = __dir__
require APP_ROOT + "/config/application.rb"
TodoApplication = Todolist::Application.new
use Rack::Reloader, 0
use Rack::MethodOverride
require APP_ROOT + "/config/routes.rb"
use Rack::Static, urls: ["/css", "/js", "/fonts"], root: APP_ROOT + "/app/assets"
run TodoApplication
