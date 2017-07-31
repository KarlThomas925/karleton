require_relative "../http_server"
require_relative "../http_response"
require 'httparty'
require 'parallel'

describe "HTTPResponse" do
  let(:response) { HTTPResponse.new }
  let(:resource_1) {IO.binread("../welcome.erb")}
  let(:resource_2) {IO.binread("../profile.erb")}
  let(:icon_link) {"<link rel='icon' type='image/png' href='bear-face-icon.png' />"}
  let(:starting_headers) {{ "Server" => "Darwin", 
                            "Content-type" => "text/html",
                            "Connection" => "close" }}
  let(:why_only_a_server) {{ "Server" => "Darwin" }}

  describe "on initialization" do
    it "has a readable status, default 200 OK" do
      expect(@response.status).to eq "200 OK"
    end

    it "has a writable status" do
      response.status = "404 Not Found"
      expect(response.status).to eq "404 Not Found"
    end

    it "has a readable resource, default is a welcome" do
      expect(response.resource).to eq resource_1
    end

    it "has a writable resource" do
      response.resource = resource_2
      expect(response.resource).to eq resource_2
    end

    it "has an icon instance variable" do
      expect(response.instance_variable_get(:@icon)).to eq icon_link
    end

    xit "has a writable" do
      
    end

    it "has a readable hash of headers" do
      expect(response.headers_hash).to eq starting_headers
    end

    it "has writable headers as well" do
      response.headers_hash = why_only_a_server
      expect(response.headers_hash).to eq why_only_a_server
    end


  end

end