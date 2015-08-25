require "swift_lint/violation"

module SwiftLint
  class Runner
    def violations_for(content)
      violation_strings = execute_swiftlint(content).split("\n")
      violation_strings.map do |violation_string|
        Violation.new(violation_string)
      end
    end

    private

    def execute_swiftlint(content)
      `printf '#{content}' | swiftlint lint --use-stdin`
    end
  end
end
