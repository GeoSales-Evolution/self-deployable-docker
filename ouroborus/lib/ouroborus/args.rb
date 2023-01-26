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

    private

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
end