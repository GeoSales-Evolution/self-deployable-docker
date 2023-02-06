# frozen_string_literal: true

module Ouroborus
  class Executor
    def exec(cmd, wrDepot = :out)
      puts cmd
      true
    end

    def willExec
      return Proc.new { |cmd, wrDepot|
        exec cmd, wrDepot
      }
    end

    def wait
      false
    end

    def execWait(cmd, wrDepot = :out)
      exec cmd, wrDepot
      wait
    end
  end

  class ShellExecutor < Executor
    def initialize(input = nil)
      @input = input
      @wrDepotMap = {}
    end

    def <<(str)
      @wr.write str
    end
    
    def exec(cmd, wrDepot = :out)
      @retValue = nil
      #wrDepot = wrDepot
      p wrDepot
      if @input.is_a? IO
        @pid = spawn("#{cmd}", :in => @input, :out => wrDepot)
      else
        rd, wr = IO.pipe
        @pid = spawn("#{cmd}", :in => rd, :out => wrDepot)
        if @input.nil?
          @wr = wr
        else
          wr.write(@input)
        end
      end
      @wrDepotMap[@pid] = wrDepot unless wrDepot == :out

      return @pid
    end

    def wait
      if @retValue.nil?
        Process.wait @pid
        outWrDepot = @wrDepotMap.delete @pid
        outWrDepot.close unless outWrDepot.nil?
        @pid = nil
        @retValue = $?.exitstatus
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

