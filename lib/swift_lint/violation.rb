module SwiftLint
  class Violation
    CLANG_REGEX = /\A
      .+:                   # File name
      (\d+):                # Line number
      (?:\d+:)?\s           # Column Number
      (?:warning|error):\s  # Type of message
      (.+)                  # Message
    \z/x

    def self.parsable?(string)
      !!(string =~ CLANG_REGEX)
    end

    def initialize(violation_string)
      @violation = violation_string
    end

    def to_hash
      {
        line: line_number,
        message: message,
      }
    end

    def line_number
      parts[:line_number].to_i
    end

    def message
      parts[:message]
    end

    private

    def parts
      matches = CLANG_REGEX.match(violation)

      if !matches || matches.length < 3
        raise ViolationParseError, %(Violation: "#{violation}")
      end

      {
        line_number: matches[1],
        message: matches[2],
      }
    end

    attr_reader :violation
  end

  class ViolationParseError < StandardError
  end
end
