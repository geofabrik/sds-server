class OsmapiController < ApplicationController

require "net/http"
require "uri"

def proxy
    uri = 'http://api.openstreetmap.org/api/0.6/' + params[:apirequest];
    if (request.query_string) 
        uri = uri + "?" + request.query_string;
    end
    result = fetch(uri);
    render :text => result
end

def fetch(uri_str, limit = 10)
  # You should choose a better exception.
  raise ArgumentError, 'too many HTTP redirects' if limit == 0

  response = Net::HTTP.get_response(URI(uri_str))

  case response
  when Net::HTTPSuccess then
    response.body
  when Net::HTTPRedirection then
    location = response['location']
    fetch(location, limit - 1)
  else
    response.value
  end
end

end
