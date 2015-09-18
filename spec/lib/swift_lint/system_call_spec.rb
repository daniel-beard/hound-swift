require "spec_helper"
require "swift_lint/system_call"

describe SwiftLint::SystemCall do
  context "running valid command" do
    it "returns the output" do
      system = SwiftLint::SystemCall.new

      output = system.call("printf 'Hello World!'")

      expect(output).to eq("Hello World!")
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
