# frozen_string_literal: true

require 'webrick'

def ouroborus_server(port = 8000)
  server = WEBrick::HTTPServer.new :Port => port

  server.mount_proc '/' do |req, res|
    res.body = 'Hello, world'
  end

  trap 'INT' do server.shutdown end

  puts 'iniciando o server'
  server.start
end
