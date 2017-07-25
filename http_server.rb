require 'socket'
require 'pry'

class HTTPserver < TCPServer
  attr_accessor :server_response, :status

  def initialize 
    @status = "200 OK"
    @server_response = []
  end

  def run
    loop do
      client = self.accept    # Wait for a client to connect
      client.each_line { |m| puts m}
      client.close
    end
  end

  def send_resource_for(requested_resource)
    find_resource(requested_resource)
    set_status_line
    set_headers
    add_resource
    self.server_response.join
  end

  def find_resource(resource_name)
    read_file = IO.binread('#{resource_name}.txt')
    if read_file
      @resource ||= IO.binread('#{resource_name}.txt')
    else
      self.status = "404 Not Found"
    end
  end

  def set_status_line
    self.server_response << "HTTP/1.1 #{self.status}\r\n"
  end

  def set_headers
    add_header("Server" => "Darwin")
    add_header("Content-type" => "text/html"))
    add_header("Content-length" => @resource.length)
    add_header("Connection" => "close")
  end

  def add_header(arg = {})
    header = arg.keys[0]
    value = arg[header]
    self.server_response << header + ": " + value + "\r\n"
  end

  def add_resource
    self.response << @resource
  end
end