require http_server.rb
server = HTTPServer.new("127.0.0.1", 2000) # Server bind to port 2000

server.run 

#   response = ["HTTP/1.1 200 OK\r\n"]
#   response << "Server: Apache\r\n"
#   response << "Content-type : text/html\r\n"
#   response << "Content-length: #{IO.binread('testfile.txt').length}\r\n"
#   response << "Connection: close\r\n"
#   response << IO.binread('testfile.txt').length
# client.puts response.join


