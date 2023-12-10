# frozen_string_literal: true

require_relative 'args'

module Ouroborus
  class RestartCondition
    class << self
      STATUSES = {
        :ALWAYS => "always",
        :NEVER => "no",
        :UNLESS_STOPPED => "unless-stopped",
        :ON_FAILURE => "on-failure"
      }
      def valid?(condition)
        STATUSES.has_key? condition
      end
      def as_string(condition)
        STATUSES[condition]
      end
    end
  end
  class Container
    attr_reader :args, :name
    def initialize(name:, image:, tag: 'latest')
      @name = name
      @image = image
      @tag = tag
      @dockerArgs = Args.new
      @args = Args.new
      @daemon = true
      @add_host = ''
    end

    def daemon?
      @daemon
    end

    def daemon=(value)
      if value
        @daemon = true
      else
        @daemon = false
      end
    end


    def add_host?
      !@add_host.empty?
    end

    def add_host=(value)
      @add_host = value.to_s
    end 

    def teste
      puts "teste >> exec branch jp"
    end

    def imgTag
      "#{@image}:#{@tag}"
    end

    def to_s
      startCommand
    end

    def as_args
      replaceable = Args.new
      replaceable << "run"
      if daemon?
        replaceable << "-d"
      else
        replaceable << "-i"
      end
      if add_host?
        replaceable << "--add-host=#{@add_host}"
      end
      replaceable << @dockerArgs << "--name" << @name << imgTag << @args
    end

    def port(incoming, interface = nil)
      p = "#{incoming}"
      p += ":#{interface}" unless interface.nil?
      @dockerArgs << '-p' << p
    end

    def autoRemove
      @dockerArgs << "--rm"
    end

    def volume(their, ours = nil)
      v = "#{their}"
      v += ":#{ours}" unless ours.nil?
      @dockerArgs << '-v' << v
    end

    def restart(condition, maxRetries = nil)
      raise "restart condition must met RestartCondition.valid?" unless RestartCondition.valid? condition
      condStr = if !maxRetries.nil?
        raise "restart maxRetries should only be set when condition is :ON_FAILURE" unless condition == :ON_FAILURE
        "#{RestartCondition.as_string condition}:#{maxRetries}"
      else
        "#{RestartCondition.as_string condition}"
      end
      @dockerArgs << '--restart' << condStr
    end

    def env(name, value = nil)
      if name.is_a? Hash
        raise "When first arg passed is a Hash, env second arg should not be passed" unless value.nil?
        name.map do |kv|
          normalizeEnvValue(*kv)
        end.each do |envvalue|
          @dockerArgs << '--env' << envvalue
        end
      elsif name.is_a? Array
        usedValue = if value.nil? then
          []
        elsif value.is_a? Array then
          usedValue = value
        else
          raise "When first arg is an Array, env second arg must be another array or should not be passed"
        end
        name.zip(usedValue).map do |kv|
          normalizeEnvValue(*kv)
        end.each do |envvalue|
          @dockerArgs << '--env' << envvalue
        end
      else
        @dockerArgs << '--env' << normalizeEnvValue(name, value)
      end
    end

    def startCommand(&block)
      replaceable = Args.new
      replaceable << "docker" << as_args
      runCommand "#{replaceable}", &block
    end

    def stopCommand(&block)
      runCommand "docker stop #{@name}", &block
    end

    def fetchImageCommand(&block)
      runCommand "docker pull #{imgTag}", &block
    end

    def removeContainerCommand(&block)
      runCommand "docker rm #{@name}", &block
    end

    private

    def normalizeEnvValue(name, value = nil)
      e = "#{name}"
      e += "=#{value}" unless value.nil?
      e
    end

    def runCommand(cmd, &block)
      if block_given? then
       yield cmd, :out
      else
        cmd
      end
    end
  end
end
