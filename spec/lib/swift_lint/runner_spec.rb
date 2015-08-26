require "spec_helper"
require "config_options"
require "swift_lint/runner"
require "swift_lint/file"

describe SwiftLint::Runner do
  it "executes proper command"do
    config = ConfigOptions.new
    file = SwiftLint::File.new("file.swift", "let x = 1")
    system_call = SwiftLint::SystemCall.new
    runner = SwiftLint::Runner.new(config, system_call: system_call)
    allow(system_call).to receive(:call).and_return("")

    runner.violations_for(file)

    expect(system_call).
      to have_received(:call).
      with("bin/hound-swiftlint \"#{config.to_yaml}\" \"#{file.content}\"")
  end
end
