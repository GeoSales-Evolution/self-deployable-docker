# frozen_string_literal: true

module Ouroborus
  class Args
    def initialize
      @v = []
    end

    def <<(x)
      @v << x
      self
    end

    def [](pos)
      @v[pos]
    end

    def empty?
      @v.empty?
    end

    def to_s
      "" if @v.empty?
      @v.map.filter_map do |arg|
        normalize_arg arg unless arg.is_a? Args and arg.empty?
      end.reduce '' do |acc, curr|
        next "#{curr}" if acc.empty?
        "#{acc} #{curr}"
      end
    end

    def normalize_arg(arg)
      return arg if arg.is_a? Args
      return normalize_arg arg.to_s unless arg.is_a? String
      return "''" if arg.empty?
      arg.chars.reduce '' do | acc, curr |
        next "#{acc}\\#{curr}" if backslasheable? curr
        "#{acc}#{curr}"
      end
    end

    def backslasheable? c
      ' \\$#\'\"'.include? c
    end
  end
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
    attr_reader :args
    def initialize(name:, image:, tag: 'latest')
      @name = name
      @image = image
      @tag = tag
      @dockerArgs = Args.new
      @args = Args.new
      @daemon = true
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

    def imgTag
      "#{@image}:#{@tag}"
    end

    def to_s
      replaceable = Args.new
      replaceable << "docker" << as_args
      "#{replaceable}"
    end

    def as_args
      replaceable = Args.new
      replaceable << "run"
      if daemon?
        replaceable << "-d"
      else
        replaceable << "-i"
      end
      replaceable << @dockerArgs << "--name" << @name << imgTag << @args
    end

    def port(incoming, interface = nil)
      p = "#{incoming}"
      p += ":#{interface}" unless interface.nil?
      @dockerArgs << '-p' << p
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
      @dockerArgs << '--env' << if name.is_a? Hash
        raise "When first arg passed is a Hash, env second arg should not be passed" unless value.nil?
        name.map do |kv|
          normalizeEnvValue(*kv)
        end.reduce("") do |acc, envvalue|
          if !acc.empty?
            acc + "," + envvalue
          else
            envvalue
          end
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
        end.reduce("") do |acc, envvalue|
          if !acc.empty?
            acc + "," + envvalue
          else
            envvalue
          end
        end
      else
        normalizeEnvValue(name, value)
      end
    end

    private

    def normalizeEnvValue(name, value = nil)
      e = "#{name}"
      e += "=#{value}" unless value.nil?
      e
    end
  end
end
