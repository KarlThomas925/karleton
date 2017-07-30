class HTTPResponse
  attr_accessor :server_response, :status, :resource, :headers_hash
  def initialize
    @status = "200 OK"
    @root_resource = IO.binread('welcome.erb')
    #   todo - when i dont have this, it breaks. l8r this will be somewhere else. 
    @icon = "<link rel='icon' type='image/png' href='bear-face-icon.png' />"
    @headers_hash = { "Server" => "Darwin", 
                      "Content-type" => "text/html",
                      "Connection" => "close" }
  end


  def sendy(resource_request)
    resource = add_resource(resource_request)
    status_line = set_status_line
    response_headers = format_headers

    construct_response(status_line, response_headers, resource)
  end 

  def construct_response(status_line, headers, resource)
    response = []
    response << status_line
    response << headers 
    response << resource
    response.join
  end

  def erb(resource_name)
    return @resource if resource_name == ""
    return @icon if resource_name == "favicon.ico"

    if read_file = IO.binread("#{resource_name}.erb")

      # the plus one is for the added linebrake of the response. 
      update_headers("Content-Length", read_file.length+1)
      self.resource = read_file
    else
      self.status = "404 Not Found"
      self.resource = "404"
      false
    end
  end 


  def add_resource(resource_request)
    ["\r\n", erb(resource_request)]
  end


  def set_status_line
    "HTTP/1.1 #{self.status}\r\n"
  end

  def format_headers
    self.headers_hash.map { |header,value| header_to_s(header => value)} 
  end

  def update_headers(header, value)
    self.headers_hash[header] = value
  end 

  def header_to_s(arg = {})
    header = arg.keys[0]
    value = arg[header]
    "#{header}: #{value} \r\n"
  end
      
end
