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
      if @input.is_a? IO
        @pid = spawn("#{cmd}", :in => @input)
      else
        rd, wr = IO.pipe
        @pid = spawn("#{cmd}", :in => rd)
        if @input.nil?
          @wr = wr
        else
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

  class HestiaExecutor < Executor
    def self.run(dockerSocket:, &commandsToExecute)
      hestia_container = Container.new name: 'hestia', image: 'hestia', tag: 'latest'
      hestia_container.daemon = false

      hestia_container.volume dockerSocket,dockerSocket
      hestia_container.autoRemove
      hestia_container.args << "--stdin"

      IO.pipe do |rd, wr|
        executor = ShellExecutor.new rd

        commandsToExecute.call wr
        begin
          hestia_container.startCommand &executor.willExec
        ensure
          puts "hestia call had ended"
        end
      end
    end
  end
end

