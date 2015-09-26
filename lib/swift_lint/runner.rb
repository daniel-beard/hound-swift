require "swift_lint/violation"
require "swift_lint/system_call"

module SwiftLint
  class Runner
    def initialize(config, system_call: SystemCall.new)
      @config = config
      @system_call = system_call
    end

    def violations_for(file)
      violation_strings(file).map do |violation_string|
        Violation.new(violation_string).to_hash
      end
    end

    private

    attr_reader :config, :system_call

    def violation_strings(file)
      result = execute_swiftlint(file).split("\n")
      result.select { |string| message_parsable?(string) }
    end

    def execute_swiftlint(file)
      cmd = "bin/hound-swiftlint " \
        "'#{escape(config.to_yaml)}' " \
        "'#{escape(file.name)}' " \
        "'#{escape(file.content)}'"
      system_call.call(cmd)
    end

    def escape(string)
      return string.gsub(/'/) { "\\047" }
    end

    def message_parsable?(string)
      SwiftLint::Violation.parsable?(string)
    end
  end
end
