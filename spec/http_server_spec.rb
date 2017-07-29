require_relative "../http_server"
require_relative "../http_response"

describe HTTPServer do
  let(:host) { "127.0.0.1" }
  let(:port) { 2000 }

  describe "On initialization" do
  
    before(:each) do 
      @server = HTTPServer.new(host, port) 
    end

    after(:each) do
      @server.tcp_server.close
    end

    it "has a readable instance of TCPServer assigned to it" do 
      expect(@server.tcp_server).to be_an_instance_of(TCPServer)
    end

    it "does NOT have a writable instance of TCPServer" do
      expect{@server.tcp_server}.to throw
    end

    it "has a readable instance of HTTPResponse to respond with." do 
      expect(@server.server_response).to be_an_instance_of(HTTPResponse)
    end

    it "does NOT have a writable instance of HTTPResponse" do
      
    end
  end  
end