require 'socket'
require 'pry'

class HTTPserver < TCPServer
  def run
    client = self.accept    # Wait for a client to connect
    client
    client.each_line { |m| puts m}
  
    client.close
  end

  def send_200_resource(resource_name)
  #   response = ["HTTP/1.1 200 OK\r\n"]
  #   response << "Server: Apache\r\n"
  #   response << "Content-type : text/html\r\n"
  #   response << "Content-length: #{IO.binread('testfile.txt').length}\r\n"
  #   response << "Connection: close\r\n"
  #   response << IO.binread('testfile.txt').length
  end
end