module SwiftLint
  class Violation

    def initialize(violation_hash)
      @violation = violation_hash
    end

    def to_hash
      {
        line: line_number,
        message: message,
      }
    end

    def line_number
      violation["line"]
    end

    def message
      violation["reason"]
    end

    private

    attr_reader :violation
  end

  class ViolationParseError < StandardError
  end
end
