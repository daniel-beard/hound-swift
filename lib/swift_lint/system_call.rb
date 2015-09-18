module SwiftLint
  class SystemCall
    class NonZeroExitStatusError < StandardError; end

    def call(cmd)
      output = run_command(cmd)
      if last_command_successful?
        output
      else
        raise NonZeroExitStatusError, "Command: '#{cmd}'"
      end
    end

    def run_command(cmd)
      `#{cmd}`
    end

    def last_command_successful?
      $?.success?
    end
  end
end
