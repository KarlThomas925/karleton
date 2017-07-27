require 'socket'
require 'pry'

class HTTPServer
  attr_accessor :server_response, :status, :server, :client_uri, :resource, :headers_hash

  def initialize(host, port)
    @server = TCPServer.new(host, port)
    @status = "200 OK"
    @resource = IO.binread('welcome.erb')
    @client_uri = nil
    # todo - when i dont have this, it breaks. l8r this will be somewhere else. 
    @icon = "<link rel='icon' type='image/png' href='bear-face-icon.png' />"
    @headers_hash = { "Server" => "Darwin", 
                      "Content-type" => "text/html",
                      "Connection" => "close" }
  end

  def run
    loop do
      client = self.server.accept    # Wait for a client to connect
      request = parse_uri(client)
      client.puts send_response_for(request)
      client.close
    end
  end


  def get(path_name, &block)
    request = "GET #{path_name} HTTP/1.1"
    $get_path_hash[request] = block
  end

  # example get request in sinatra 
  # get "/welcome" do 
  #   @first = params[:first]
  #   @last =  params[:last]
  #   find_resource :welcome
  # end



  def send_response_for(resource_request)
    resource = add_resource(resource_request)
    status_line = set_status_line
    response_headers = format_headers

    construct_response(status_line, response_headers, resource)
  end

  def find_resource(resource_name)
    return @resource if resource_name == ""
    return @icon if resource_name == "favicon.ico"

    if read_file = IO.binread("#{resource_name}.erb")

      # the plus one is for the added linebrake of the response. 
      update_headers("Content-Length", read_file.length+1)
      self.resource = read_file
    else
      self.status = "404 Not Found"
      false
    end
  end

  def add_resource(resource_request)
    ["\r\n", find_resource(resource_request)]
  end

  def construct_response(status_line, headers, resource)
    response = []
    response << status_line
    response << headers 
    response << resource
    response.join
  end

  def set_status_line
    "HTTP/1.1 #{self.status}\r\n"
  end

  def format_headers
    self.headers_hash.map { |header,value| header_to_s(header => value)} 
  end

  def update_headers(header, value)
    self.headers_hash[header] = value
  end

  def header_to_s(arg = {})
    header = arg.keys[0]
    value = arg[header]
    "#{header}: #{value} \r\n"
  end

  def parse_uri(client_request)
    uri = client_request.first.split[1]
    uri[0] = ""
    uri
  end 

  def path_name(uri)
    if uri.include?("?")
      uri.partition("?")[0]
    else
      uri
    end
  end

  def query_string(uri)
    uri.partition("?")[2]
  end

  def create_query_params(query_string)
    CGI::parse(query_string)
  end
  
  def format_request_line(path_name)
    "GET #{path_name} HTTP/1.1"
  end
end