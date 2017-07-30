require_relative "../http_server"
require_relative "../http_response"

describe HTTPServer do
  let(:host) { "127.0.0.1" }
  let(:port) { 2000 }
  let(:example_client_request) {<<~HEREDOC
                                    GET /profile HTTP/1.1
                                    Host: 127.0.0.1:2000
                                    User-Agent: curl/7.49.1
                                    Accept: */*
                                HEREDOC
                                }
  around(:each) do |example|
    @server = HTTPServer.new(host, port) 
    example.run
    @server.tcp_server.close
  end
  
  describe "On initialization" do
    it "has a readable instance of TCPServer assigned to it" do 
      expect( @server.tcp_server ).to be_an_instance_of(TCPServer)
    end

    it "does NOT have a writable instance of TCPServer" do
      expect{ @server.tcp_server = "paul" }.to raise_error(NoMethodError)
    end

    it "has a readable instance of HTTPResponse to respond with." do 
      expect( @server.server_response ).to be_an_instance_of(HTTPResponse)
    end

    it "does NOT have a writable instance of HTTPResponse" do
       expect{ @server.server_response = "qymana" }.to raise_error(NoMethodError)
    end
  end 

  describe "header_to_s" do
    it "formats a key value pair in HTTP response header format" do
      correctly_formated_header = "Header: value \r\n"
      expect(@server.header_to_s(Header: "value")).to eq correctly_formated_header
    end
  end

  describe "parse_uri" do
    it "only keeps the uri from the client request" do
      expect(@server.parse_uri(example_client_request)).to not_include "HTTP/1.1"
      puts example_client_request.methods.sort
    end
  end

end

