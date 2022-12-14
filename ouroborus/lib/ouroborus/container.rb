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

    def to_s
      tmp = @v.map do |arg|
        normalize_arg arg
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
  class Container
    attr_reader :args
    def initialize(name:, image:, tag: 'latest')
      @name = name
      @image = image
      @tag = tag
      @args = Args.new
    end

    def imgTag
      "#{@image}:#{@tag}"
    end

    def to_s
      "#{@args}"
    end
  end
end
