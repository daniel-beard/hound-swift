require "spec_helper"
require "config_options"
require "swift_lint/runner"
require "swift_lint/file"

describe SwiftLint::Runner do
  it "executes proper command"do
    swift_lint_version = "1.0"
    config = ConfigOptions.new
    file = swift_file
    system_call = stubbed_system_call
    runner = SwiftLint::Runner.new(config, system_call: system_call)

    with_default_swift_lint_version(swift_lint_version) do
      runner.violations_for(file)
    end

    expect(system_call).
      to have_received(:call).
      with(expected_shell_command(swift_lint_version, config, file))
  end

  describe "custom swiftlint version" do
    it "executes proper command" do
      swift_lint_version = "2.0"
      config = ConfigOptions.new({"version" => swift_lint_version}.to_yaml)
      file = swift_file
      system_call = stubbed_system_call
      runner = SwiftLint::Runner.new(config, system_call: system_call)

      with_default_swift_lint_version("1.0") do
        runner.violations_for(file)
      end

      expect(system_call).
        to have_received(:call).
        with(expected_shell_command(swift_lint_version, config, file))
    end
  end

  def expected_shell_command(version, config, file)
    "bin/hound-swiftlint " \
      "\"#{version}\" " \
      "\"#{config.to_swiftlint_yaml}\" " \
      "\"#{file.content}\""
  end

  def swift_file
    SwiftLint::File.new("file.swift", "let x = 1")
  end

  def stubbed_system_call
    system_call = SwiftLint::SystemCall.new
    allow(system_call).to receive(:call).and_return("")
    system_call
  end

  def with_default_swift_lint_version(version, &block)
    ClimateControl.modify(SWIFT_LINT_VERSION: version.to_s, &block)
  end
end
