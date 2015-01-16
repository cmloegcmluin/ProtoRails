require 'webrick'
require_relative '../lib/rails_lite/controller_base'
require_relative '../lib/rails_lite/router'
require_relative '../config/routes.rb'
require_relative '../db/db_connection'
require_relative '../app/requires.rb'

router = Router.new
router.draw(&Routes::routes)

DBConnection.reset

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') { |req, res| route = router.run(req, res) }
trap('INT') { server.shutdown }
server.start
