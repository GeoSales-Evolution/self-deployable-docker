# frozen_string_literal: true

module Ouroborus
  class Executor
    def exec(cmd)
      puts cmd
      true
    end

    def willExec
      return Proc.new { |cmd|
        exec cmd
      }
    end

    def wait
      false
    end
  end

  class ShellExecutor < Executor
    def initialize(input = nil)
      @input = input
    end

    def <<(str)
      @wr.write str
    end
    
    def exec(cmd)
      p "comando passado", cmd
      if @input.is_a? IO
        p 'modo IO'
        @pid = spawn("#{cmd}", :in => @input)
        p @pid
      else
        p 'modo pipe'
        rd, wr = IO.pipe
        @pid = spawn("#{cmd}", :in => rd)
        if @input.nil?
          p 'modo write'
          @wr = wr
        else
          p 'escreveu string'
          wr.write(@input)
        end
      end
      return @pid
    end

    def wait
      unless @retValue.nil?
        Process.wait @pid
        @retValue = $?.exitStatus
      end
      @retValue == 0
    end
  end
end

