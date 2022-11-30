# frozen_string_literal: true

require 'webrick'

server = WEBrick::HTTPServer.new :Port => 8000

server.mount_proc '/' do |req, res|
  res.body = 'Hello, world'
end

trap 'INT' do server.shutdown end

puts 'iniciando o server'
server.start
