require 'socket'

server = TCPServer.new 2000 # Server bind to port 2000

loop do
  client = server.accept    # Wait for a client to connect
  input = client.gets.chomp
  case input
  when "home"
    client.puts "you home now\n"
  when "profile"
    client.puts "name: Karl\n info: he does things \n"
  else
    client.puts "what \n"
  end

  client.close
end