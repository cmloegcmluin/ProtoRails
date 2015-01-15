require 'uri'

class Params

  def initialize(req, route_params = {})
    @params = route_params
    @params.merge!(parse_www_encoded_form(req.body)) if req.body
    @params.merge!(parse_www_encoded_form(req.query_string)) if req.query_string
  end

  def [](key)
    @params[key.to_s]
  end

  def to_s
    @params.to_json.to_s
  end

  class AttributeNotFoundError < ArgumentError
  end

  private

  def parse_www_encoded_form(www_encoded_form)
    params = {}
    keys = URI.decode_www_form(www_encoded_form)
    keys.each do |key_chunk, value|
      current_node = params
      key_seq = parse_key(key_chunk)
      key_seq.each_with_index do |key, idx|
        if (idx + 1) == key_seq.count
          current_node[key] = value
        else
          current_node[key] ||= {}
          current_node = current_node[key]
        end
      end
    end

    params
  end

  def parse_key(key)
    key.split(/\]\[|\[|\]/)
  end
end
