# This file is used by Rack-based servers to start the application.

require ::File.expand_path('../config/environment', __FILE__)
run Rails.application
#run Proc.new {|env| [200, {"Content-Type" => "text/html"}, "Hello World!<br />"+env.inspect]}
