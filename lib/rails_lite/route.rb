class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
      pattern, http_method, controller_class, action_name
    add_url_helpers
  end

  def matches?(req)
    req_method = req.request_method.downcase.to_sym
    ((req.path =~ pattern) == 0) && req_method == http_method
  end

  def run(req, res)
    match_data = pattern.match(req.path)
    params = {}
    match_data.to_a.drop(1).each_with_index do |md, idx|
      #params[match_data.names[idx].to_sym] = md
      params[match_data.names[idx]] = md
    end

    ###apparently this works?
    # match_data.names.each do |name|
    #   route_params[name] = match_data[name]
    # end

    #debugger
    controller_class.new(req, res, params).invoke_action(action_name)
  end

  private

  def add_url_helpers
    case action_name
    when :edit
      name = "edit_#{ class_name_singular }"
      add_url_method(name, "/#{ class_name_plural }/:id/edit")
    when :new
      name = "new_#{ class_name_singular }"
      add_url_method(name, "/#{ class_name_plural }/new")
    when :show, :destroy, :update
      name = "#{ class_name_singular }"
      add_url_method(name, "/#{ class_name_plural }/:id")
    when :index, :create
      name = "#{ class_name_plural }"
      add_url_method(name, "/#{ name }")
    end
  end

  def class_name
    controller_class.to_s.underscore.gsub('_controller', '')
  end

  def class_name_plural
    class_name.pluralize
  end

  def class_name_singular
    class_name.singularize
  end

  def add_url_method(name, path)
    url_name = "#{ name }_url"
    puts "#{ url_name } #=> #{ path }"

    URLHelpers.send(:define_method, url_name) do |*args|
      id = args.first.to_s
      if path.include?(':id') && !id.nil?
        path.gsub!(':id', id)
      end
      path
    end
  end
end
