require "open3"

module SwiftLint
  class SystemCall
    class NonZeroExitStatusError < StandardError; end

    def call(cmd)
      run_command(cmd)

      if last_command_successful?
        command_output
      else
        raise NonZeroExitStatusError, "Command: '#{cmd}'"
      end
    end

    private

    attr_reader :command_output, :command_status

    def run_command(cmd)
      @command_output, @command_status = Open3.capture2(cmd)
    end

    def last_command_successful?
      command_status.success?
    end
  end
end
