require "spec_helper"
require "config_options"
require "swift_lint/runner"
require "swift_lint/file"

describe SwiftLint::Runner do
  describe "#violations_for" do
    it "executes proper system command to get violations"do
      config = ConfigOptions.new("")
      file = SwiftLint::File.new("file.swift", "let x = 1")
      system_call = SwiftLint::SystemCall.new
      allow(system_call).to receive(:call).and_return("")
      runner = SwiftLint::Runner.new(config, system_call: system_call)

      runner.violations_for(file)

      args = %("#{config.to_yaml}" "#{file.name}" "#{file.content}")
      expected_command = "bin/hound-swiftlint #{args}"
      expect(system_call).to have_received(:call).with(expected_command)
    end
  end
end
