require 'socket'
require 'pry'

class HTTPServer
  attr_accessor :server_response, :status, :server, :client_uri, :resource

  def initialize(host, port)
    @server = TCPServer.new(host, port)
    @status = "200 OK"
    @server_response = []
    @resource = IO.binread('welcome.txt')
    @client_uri = nil
  end

  def run
    loop do
      client = self.server.accept    # Wait for a client to connect
      client.puts client.methods.sort
      client.puts "###****** _|____|_  ``(._.``)   ******####"
      resource_request = parse_uri(client)
      client.puts resource_request
      client.puts send_resource_for(resource_request)
      client.close
    end
  end

  def send_resource_for(resource_request)
    find_resource(resource_request)
    set_status_line
    set_headers
    add_resource
    self.server_response.join
  end

  def find_resource(resource_name)
    return @resource if resource_name == ""
    
    if read_file = IO.binread("#{resource_name}.txt")
      @resource = read_file
    else
      self.status = "404 Not Found"
    end
  end

  def set_status_line
    self.server_response << "HTTP/1.1 #{self.status}\r\n"
  end

  def set_headers
    add_header("Server" => "Darwin")
    add_header("Content-type" => "text/html")
    add_header("Content-length" => @resource.length)
    add_header("Connection" => "close")
  end

  def add_header(arg = {})
    header = arg.keys[0]
    value = arg[header]
    self.server_response << "#{header}: #{value} \r\n"
  end

  def add_resource
    self.server_response << "\r\n"
    self.server_response << @resource
  end

  def parse_uri(client_request)
    uri = client_request.first.split[1]
    uri[0] = ""
    self.client_uri = uri
  end 

end