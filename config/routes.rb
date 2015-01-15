router = Router.new
router.draw do
  # get Regexp.new("^/cats$"), Cats2Controller, :index
  # get Regexp.new("^/cats/(?<cat_id>\\d+)/statuses$"), StatusesController, :index
  get Regexp.new("^/pants$"), PantsController, :index
end
