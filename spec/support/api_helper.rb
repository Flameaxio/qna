module APIHelper
  def do_request(type, options = {})
    send(type.to_sym, url, params: { format: :json }.merge(options))
  end
end
