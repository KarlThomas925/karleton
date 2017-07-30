require 'socket'
require 'pry'
require_relative 'http_response'

class HTTPServer
  attr_reader :server_response, :tcp_server

  def initialize(host, port)
    @tcp_server = TCPServer.new(host, port)
    @server_response = HTTPResponse.new
  end

  def run
    loop do
      client = self.accept_client    # Wait for a client to connect
      puts client 
      puts client.class
      puts client.methods.sort
      request = parse_uri(client)
      client.puts self.server_response.sendy(request)
      client.close
    end
  end

  def accept_client
    self.tcp_server.accept
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

  def handle_get_request(client_request)
    parse_uri(client_request)
    path_name(uri)
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