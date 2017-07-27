require_relative 'http_server'

$get_path_hash = {}

server = HTTPServer.new("127.0.0.1", 2000) # Server bind to port 2000

server.run


# get "/thing/:id" do

#   erb :template
# end

# {"get /thing http 1.1" => block}



# def get(path_string, &block)

#   global_ish_hash[path_string] = block;
# end


# def handle_incoming_get_request(path_string, params)

#   block_to_run = global_ish_hash.find(path_string)

#   return block_to_run.call(params)

# end