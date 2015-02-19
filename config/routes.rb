module Routes
  def self.routes
    Proc.new {
      get Regexp.new("^/pants$"), PantsController, :index
      get Regexp.new("^/pants/new$"), PantsController, :new
      post Regexp.new("^/pants$"), PantsController, :create
      get Regexp.new("^/pants/(?<id>\\d+)$"), PantsController, :show

      get Regexp.new("^/shoes/new$"), ShoesController, :new
      post Regexp.new("^/shoes$"), ShoesController, :create

      get Regexp.new("^/session/new$"), SessionsController, :new
      post Regexp.new("^/session$"), SessionsController, :create
      post Regexp.new("^/session$"), SessionsController, :destroy

      get Regexp.new("^/users/(?<id>\\d+)$"), UsersController, :show
      post Regexp.new("^/users$"), UsersController, :create
    }
  end
end
