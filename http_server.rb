require 'socket'
require 'pry'

class HTTPserver < TCPServer
  attr_accessor :server_response

  def initialize 
    @server_response = []
  end

  def run
    client = self.accept    # Wait for a client to connect
    client
    client.each_line { |m| puts m}
  
    client.close
  end

  def send_resource(status, resource_name)
    determine_status(status)
    set_resource(resource_name)
    set_headers
    add_resource
    self.server_response.join
  end

  def determine_status(status)
    case status
    when 200
      self.server_response << "HTTP/1.1 200 OK\r\n"
    end
  end

  def set_resource(resource_name)
    @resource ||= IO.binread('#{resource_name}.txt')
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