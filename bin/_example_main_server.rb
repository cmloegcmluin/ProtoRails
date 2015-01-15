# require 'webrick'
# require_relative '../lib/main/controller_base'
# require_relative '../lib/main/router'
#
# router = Router.new
# server = WEBrick::HTTPServer.new(Port: 3000)
# server.mount_proc('/') { |req, res| route = router.run(req, res) }
# trap('INT') { server.shutdown }
# server.start

# require 'active_support/core_ext'
require 'webrick'
require_relative '../lib/rails_lite/controller_base'
require_relative '../lib/rails_lite/router'
require_relative '../app/controllers/pants_controller'
require_relative '../config/routes.rb'
require_relative '../db/_example_db_connection'

# class MyController < ControllerBase
#   def go
#     if @req.path == "/cats"
#       render_content("hello cats!", "text/html")
#     else
#       redirect_to("/cats")
#     end
#   end
#
#   def go_03
#     render :show
#   end
#
#   def go_04
#     session["count"] ||= 0
#     session["count"] += 1
#     render :counting_show
#   end
# end
#
# class Cat
#   attr_reader :name, :owner
#
#   def self.all
#     @cat ||= []
#   end
#
#   def initialize(params = {})
#     params ||= {}
#     @name, @owner = params["name"], params["owner"]
#   end
#
#   def save
#     return false unless @name.present? && @owner.present?
#
#     Cat.all << self
#     true
#   end
#
#   def inspect
#     { name: name, owner: owner }.inspect
#   end
# end
#
# class CatsController < ControllerBase
#   def create
#     @cat = Cat.new(params["cat"])
#     if @cat.save
#       redirect_to("/cats")
#     else
#       render :new
#     end
#   end
#
#   def index
#     @cats = Cat.all
#     render :index
#   end
#
#   def new
#     @cat = Cat.new
#     render :new
#   end
# end

$cats = [
  { id: 1, name: "Curie" },
  { id: 2, name: "Markov" }
]

$statuses = [
  { id: 1, cat_id: 1, text: "Curie loves string!" },
  { id: 2, cat_id: 2, text: "Markov is mighty!" },
  { id: 3, cat_id: 1, text: "Curie is cool!" }
]

class StatusesController < ControllerBase
  def index
    statuses = $statuses.select do |s|
      #debugger
      s[:cat_id] == Integer(params[:cat_id])
    end

    render_content(statuses.to_s, "text/text")
  end
end

class Cats2Controller < ControllerBase
  def index
    render_content($cats.to_s, "text/text")
  end
end

###would like to put this in config/routes??? yeah, it should be stored there as a proc and ported over
router = Router.new
router.draw do
  get Regexp.new("^/cats$"), Cats2Controller, :index
  get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
  get Regexp.new("^/pants$"), PantsController, :index

end

DBConnection.reset

server = WEBrick::HTTPServer.new(Port: 3000)
server.mount_proc('/') do |req, res|
  # MyController.new(req, res).go
  # MyController.new(req, res).go_03
  # MyController.new(req, res).go_04
  # case [req.request_method, req.path]
  # when ['GET', '/cats']
  #   CatsController.new(req, res, {}).index
  # when ['POST', '/cats']
  #   CatsController.new(req, res, {}).create
  # when ['GET', '/cats/new']
  #   CatsController.new(req, res, {}).new
  # end
  route = router.run(req, res)
end

trap('INT') { server.shutdown }
server.start
