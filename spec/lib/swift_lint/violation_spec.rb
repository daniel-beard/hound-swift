require "spec_helper"
require "swift_lint/violation"

describe SwiftLint::Violation do
  describe ".parsable?" do
    context "given a valid clang violation" do
      it "should parse full clang violation" do
        parsable = SwiftLint::Violation.parsable?(violation_string)

        expect(parsable).to eq(true)
      end

      it "should parse a clang violation without a column number" do
        parsable = SwiftLint::Violation.parsable?(
          violation_string_without_column,
        )

        expect(parsable).to eq(true)
      end
    end

    context "given an invalid violation" do
      it "should not be able to parse" do
        parsable = SwiftLint::Violation.parsable?("Invalid string")

        expect(parsable).to eq(false)
      end
    end
  end

  describe "#line_number" do
    it "returns line number" do
      violation = SwiftLint::Violation.new(violation_string(line_number: 1))

      expect(violation.line_number).to eq(1)
    end

    it "raises with an invalid string" do
      violation = SwiftLint::Violation.new("invalid string")

      expect { violation.line_number }.
        to raise_error(
          SwiftLint::ViolationParseError,
          /Violation: "invalid string"/,
        )
    end
  end

  describe "#message" do
    it "returns the message" do
      message = "Trailing Whitespace Violation: It should not have whitespace."
      violation = SwiftLint::Violation.new(violation_string(message: message))

      expect(violation.message).to eq(message)
    end

    it "raises with an invalid string" do
      violation = SwiftLint::Violation.new("invalid string")

      expect { violation.message }.
        to raise_error(
          SwiftLint::ViolationParseError,
          /Violation: "invalid string"/,
        )
    end
  end

  def violation_string(line_number: 1, message: default_violation_message)
    "/tmp/test.swift:#{line_number}:1: warning: #{message}"
  end

  def default_violation_message
    "Trailing Whitespace Violation (Medium Severity): " \
      "Line #1 should have no trailing whitespace: " \
      "current has 1 trailing whitespace characters"
  end

  def violation_string_without_column
    "/tmp/test.swift:1: warning: " \
      "Trailing Whitespace Violation (Medium Severity): " \
      "Line #1 should have no trailing whitespace: " \
      "current has 1 trailing whitespace characters"
  end
end
