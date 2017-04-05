require 'net/http'
require 'nokogiri'

# Base class to fetch different lyrics sites
class Wiki
  def fetch(uri_str, limit = 10)
    raise ArgumentError, 'The wiki site is redirecting too much, aborting...' if limit.zero?
    uri = prepare_url(uri_str)
    response = Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      handle_request(http, uri_str, uri, limit)
    end
    handle_response(response, limit)
  end

  def handle_request(http, uri_str, uri, limit)
    req = Net::HTTP::Get.new(uri.path)
    begin
      http.request(req)
    rescue EOFError
      fetch(uri_str, limit - 1)
    end
  end

  def handle_response(response, limit)
    case response
    when Net::HTTPRedirection then
      fetch(response['location'], limit - 1)
    else
      response
    end
  end

  def prepare_url(uri_str)
    uri_str.gsub!('%EF%BB%BF', '') # fix BOM
    URI.parse(uri_str)
  end
end
