require "spec_helper"
require "config_options"
require "swift_lint/runner"
require "swift_lint/file"

describe SwiftLint::Runner do
  describe "#violations_for" do
    it "executes proper escaped system command to get violations"do
      config = ConfigOptions.new("")
      file = SwiftLint::File.new("file.swift", "let x = 'Hello'")
      system_call = SwiftLint::SystemCall.new
      allow(system_call).to receive(:call).and_return("")
      runner = SwiftLint::Runner.new(config, system_call: system_call)

      runner.violations_for(file)

      args = "'#{config.to_yaml}' '#{file.name}' 'let x = \\047Hello\\047'"
      expected_command = "bin/hound-swiftlint #{args}"
      expect(system_call).to have_received(:call).with(expected_command)
    end

    if /darwin/ =~ RUBY_PLATFORM
      it "returns all violations" do
        config = ConfigOptions.new("")
        file = SwiftLint::File.new("file.swift", swift_file_content)
        runner = SwiftLint::Runner.new(config)

        violations = runner.violations_for(file)

        expect(violations.size).to eq(2)
      end
    end
  end

  def swift_file_content
    content = <<-SWIFT
/**
    this line violates the line length contraint. this line violates the line length contraint. this line violates the line length contraint.
*/
public func <*> <T, U>(f: (T -> U)?, a: T?) -> U? {
    print('using a function wrapped in single quotes')
    print('using a function wrapped in double quotes')
    print('using backticks `')
    let colonOnWrongSide :Int = 0
    return a.apply(f)
}
    SWIFT
  end
end
