# frozen_string_literal: true

require 'webrick'

class ShutDownServlet < WEBrick::HTTPServlet::AbstractServlet
  def initialize server, suicide_squad
    super server
    @suicide_squad = suicide_squad
  end
  def do_PUT request, response
    response.status = 200
    response.content_type = "text/plain"
    response.body = 'Ok, bye!'

    @suicide_squad.call
  end
end

def ouroborus_server(port = 8000)
  server = WEBrick::HTTPServer.new :Port => port

  server.mount_proc '/' do |req, res|
    if req.path != '/' then
      res.status = 404
      res.content_type = "text/plain"
      res.body = 'oops'
      next
    end
    if req.request_method != 'GET' then
      res.status = 405
      res.content_type = "text/plain"
      res.body = "oops, use GET instead of #{req.request_method}"
      next
    end
    puts "req #{req.path}"
    res.body = 'Hello, world'
  end
  puts 'montar servlet'
  suicide_squad = -> {
    Thread.new do
      sleep 2
      server.shutdown
    end
  }
  server.mount '/shutdown', ShutDownServlet, suicide_squad
  puts 'montou servlet'

  trap 'INT' do server.shutdown end

  puts 'iniciando o server'
  server.start
end
