require "spec_helper"
require "swift_lint/system_call"

describe SwiftLint::SystemCall do
  context "running valid command" do
    it "captures stdout" do
      system = SwiftLint::SystemCall.new

      output = system.call("printf 'Hello World!'")

      expect(output).to eq("Hello World!")
    end

    it "captures stderr" do
      system = SwiftLint::SystemCall.new

      output = system.call("printf 'Hello World!' 1>&2")

      expect(output).to eq("Hello World!")
    end

    it "captures and concats stdout and stderr" do
      system = SwiftLint::SystemCall.new

      command = "printf 'Hello Stdout!' && printf 'Hello Stderr!' 1>&2"
      output = system.call(command)

      expect(output).to eq("Hello Stdout!Hello Stderr!")
    end
  end

  context "running an invalid command" do
    it "raises an error" do
      system = SwiftLint::SystemCall.new

      expect { system.call("printf") }.
        to raise_error(
          SwiftLint::SystemCall::NonZeroExitStatusError,
          "Command: 'printf'",
        )
    end
  end
end
