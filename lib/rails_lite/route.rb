class Route
  attr_reader :pattern, :http_method, :controller_class, :action_name

  def initialize(pattern, http_method, controller_class, action_name)
    @pattern, @http_method, @controller_class, @action_name =
    pattern, http_method, controller_class, action_name
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
end
