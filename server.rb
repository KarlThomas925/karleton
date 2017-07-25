require_relative 'http_server'
server = HTTPServer.new("127.0.0.1", 2000) # Server bind to port 2000

server.run


