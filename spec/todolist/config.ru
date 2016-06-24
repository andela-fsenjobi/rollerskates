APP_ROOT = __dir__
require_relative "./config/application.rb"
TodoApplication = Todolist::Application.new
use Rack::Reloader, 0
use Rack::MethodOverride
require_relative "./config/routes.rb"
use Rack::Static, urls: ["/css", "/js", "/fonts"],
                  root: APP_ROOT + "/app/assets"
run TodoApplication
