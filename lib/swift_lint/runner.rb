require "swift_lint/violation"

module SwiftLint
  class Runner
    def violations_for(file)
      violation_strings = execute_swiftlint(file.content).split("\n")
      violation_strings.map do |violation_string|
        Violation.new(violation_string).to_hash
      end
    end

    private

    def execute_swiftlint(content)
      `printf '#{content}' | swiftlint lint --use-stdin`
    end
  end
end
