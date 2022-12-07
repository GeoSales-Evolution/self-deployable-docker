# frozen_string_literal: true

module Ouroborus
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

  class RespawnServlet < WEBrick::HTTPServlet::AbstractServlet
    def initialize server, suicide_squad, port
      super server
      @suicide_squad = suicide_squad
      @port = port
    end
    def do_PUT request, response
      response.status = 200
      response.content_type = "text/plain"
      response.body = hestia

      @suicide_squad.call
    end

    def hestia
      docker_socket = "/var/run/docker.sock"
      docker_socket_bind = "-v #{docker_socket}:#{docker_socket}"
      port_bind = "-p #{@port}:#{@port}"
      `docker run -d #{docker_socket_bind} hestia -- run -d --restart unless-stopped #{port_bind} #{docker_socket_bind} ouroborus:latest`
    end
  end

  def self.ouroborus_server(port = 8000)
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
    server.mount '/respawn', RespawnServlet, suicide_squad, port
    puts 'montou servlet'

    trap 'INT' do server.shutdown end

    puts 'iniciando o server'
    server.start
    hostname=`hostname`
    puts `docker stop #{hostname}`
  end
end
