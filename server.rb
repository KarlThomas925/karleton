require 'socket'
server = TCPServer.new("127.0.0.1", 2000) # Server bind to port 2000

loop do
  client = server.accept    # Wait for a client to connect
  response = ["HTTP/1.1 200 OK\r\n"]
  response << "Server: Darwin\r\n"
  response << "Content-type : text/html\r\n"
  response << "Content-length: #{IO.binread('testfile.txt').length}\r\n"
  response << "Connection: close\r\n"
  response << "\r\n"
  response << IO.binread('testfile.txt')
  puts response.join
  client.puts response.join
  client.close
end

  # n_r = "Server: Apache/2.4.1\n"
  # n_r << "Content-type: text/html\n"
  # n_r << "Content-length: #{IO.binread('testfile.txt').length}\n"
  # n_r << "Connection: close\n"
  # n_r << "\n"
  # n_r << IO.binread('testfile.txt')