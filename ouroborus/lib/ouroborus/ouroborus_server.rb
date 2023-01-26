# frozen_string_literal: true

require 'webrick'
require_relative 'container'
require_relative 'executor'

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
      hestia_container = Container.new name: 'hestia', image: 'hestia', tag: 'latest'
      hestia_container.daemon = false

      docker_socket = "/var/run/docker.sock"
      hestia_container.volume docker_socket,docker_socket
      hestia_container.autoRemove

      ouroborus_container = Container.new name: 'ouroborus', image: 'ouroborus', tag: 'latest'

      ouroborus_container.restart :UNLESS_STOPPED
      ouroborus_container.port @port,@port
      ouroborus_container.volume docker_socket,docker_socket

      hestia_container.args << "--stdin"

      IO.pipe do |rd, wr|
        executor = ShellExecutor.new rd

        wr.puts "#{ouroborus_container.stopCommand}"
        wr.puts "#{ouroborus_container.removeContainerCommand}"
        wr.puts "#{ouroborus_container.startCommand}"
        begin
          hestia_container.startCommand &executor.willExec
        ensure
          puts "hestia call had ended"
        end
      end
    end
  end

  class OuroborusServer < WEBrick::HTTPServer
    def initialize(port, isDocker)
      super :Port => port
      @isDocker = isDocker
    end

    def start
      puts 'starting ouroborus server'
      super
    end

    def shutdown
      super
      stopActions
    end

    def stopActions
      return unless @isDocker
      hostname=`hostname`
      puts `docker stop #{hostname}`
    end

    def to_s
      super
    end
  end

  def self.ouroborus_server(port = 8000, docker = true)
    server = OuroborusServer.new(port, docker)

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
    server
  end
end
