require_relative "../http_server"
require_relative "../http_response"
require 'httparty'
require 'parallel'

describe HTTPServer do
  let(:host) { "127.0.0.1" }
  let(:port) { 2000 }
  let(:example_uri) {"/words/more_words?oh=hey"}
  let(:example_client_request) {[ "GET /profile HTTP/1.1",
                                  "Host: 127.0.0.1:2000"]}

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

  describe "#header_to_s" do
    it "formats a key value pair in HTTP response header format" do
      correctly_formated_header = "Header: value \r\n"
      expect(@server.header_to_s(Header: "value")).to eq correctly_formated_header
    end
  end

  describe "#accept_client" do 
    it "has the server wait for a client and then intercepts their request" do
      TCPSocket.new(@server.host, @server.port)
      client = @server.accept_client
      expect(client).to be_an_instance_of TCPSocket
    end
  end

  describe "#parse_uri" do
    it "only keeps the first line of a client request" do
      expect(@server.parse_uri(example_client_request)).to_not include "Host:"
    end
    it "only keeps the uri from the first line of a client request" do
      expect(@server.parse_uri(example_client_request)).to_not include "HTTP/1.1"
    end
  end


  describe "#path_name" do
    context "with query strings" do
      it "extracts the path from a URI" do
        expect(@server.path_name(example_uri)).to eq "/words/more_words"
      end
    end
    context "without query strings" do
      it "behaves the same way" do
        no_queries = "/words/more_words"
        expect(@server.path_name(no_queries)).to eq no_queries
      end
    end
  end

  describe "#query_string" do
    it "takes the URI and only keeps query strings" do
      expect(@server.query_string(example_uri)).to eq "oh=hey"
    end
  end

  describe "#create_query_params" do
    context "when query strings are present" do
      it "turns the query strings into a hash" do
        expect(@server.create_query_params(example_uri)).to eq
      end
    end

  end



end

