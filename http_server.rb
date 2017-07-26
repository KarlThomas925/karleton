require 'socket'
require 'pry'

class HTTPServer
  attr_accessor :server_response, :status, :server, :client_uri, :resource

  def initialize(host, port)
    @server = TCPServer.new(host, port)
    @status = "200 OK"
    @resource = IO.binread('welcome.erb')
    @client_uri = nil
    # todo - when i dont have this, it breaks. 
    @icon = "<link rel='icon' type='image/png' href='bear-face-icon.png' />"  
end

  def run
    loop do
      client = self.server.accept    # Wait for a client to connect
      resource_request = parse_uri(client)
      client.puts send_resource_for(resource_request)
      client.close
    end
  end

  def send_resource_for(resource_request)
    resource = find_resource(resource_request)
    status_line = set_status_line

    construct_response(status_line, response_headers(resource), resource)
  end

  def find_resource(resource_name)
    return @resource if resource_name == ""
    return @icon if resource_name == "favicon.ico"

    if read_file = IO.binread("#{resource_name}.erb")
      @resource = read_file
    else
      self.status = "404 Not Found"
      false
    end
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

  def response_headers(resource)
    headers = [ header("Server" => "Darwin"),
                header("Content-type" => "text/html"),
                header("Content-length" => resource.length),
                header("Connection" => "close") ]
  end


  def header(arg = {})
    header = arg.keys[0]
    value = arg[header]
    "#{header}: #{value} \r\n"
  end

  def add_resource
    "\r\n" + @resource
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
end