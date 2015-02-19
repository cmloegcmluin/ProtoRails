require 'json'
require 'webrick'

class HashWithIndifferentAccess < Hash
  def [](key)
    super(key.to_s)
  end

  def []=(key, val)
    super(key.to_s, val)
  end
end

class Flash
  def initialize(req)
    cookie = req.cookies.find { |c| c.name == '_integrated_active_record_lite_and_rails_lite_app' }

    @flash_now = HashWithIndifferentAccess.new
    @data = HashWithIndifferentAccess.new

    if cookie
      JSON.parse(cookie.value).each do |k, v|
        @flash_now[k] = v
      end
    end
  end

  def now
    @flash_now
  end

  def [](key)
    now[key] || @data[key]
  end

  def []=(key, val)
    now[key] = val
    @data[key] = val
  end

  def store_flash(res)
    cook = WEBrick::Cookie.new(
    "_integrated_active_record_lite_and_rails_lite_app",
    @data.to_json
    )
    cook.path = "/"
    res.cookies << cook
  end
end
