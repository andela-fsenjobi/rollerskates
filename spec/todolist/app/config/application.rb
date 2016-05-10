require 'rollerskates'
$LOAD_PATH << File.join(File.dirname(__FILE__), '..', '..', 'app', 'controllers')

module Todolist
  class Application < Rollerskates::Application
  end
end
