module Routes
  def self.routes
    Proc.new {
      get Regexp.new("^/pants$"), PantsController, :index
      get Regexp.new("^/pants/new$"), PantsController, :new
      post Regexp.new("^/pants$"), PantsController, :create
      get Regexp.new("^/shoes/new$"), ShoesController, :new
      post Regexp.new("^/shoes$"), ShoesController, :create
    }
  end
end
