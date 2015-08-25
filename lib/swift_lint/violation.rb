module SwiftLint
  class Violation
    LINE_NUMBER_REGEX = /<nopath>:(\d+)/
    MESSAGE_REGEX = /(?:warning|error):\s?(.+)/

    def initialize(violation_string)
      @violation = violation_string
    end

    def line_number
      LINE_NUMBER_REGEX.match(violation)[1].to_i
    end

    def message
      MESSAGE_REGEX.match(violation)[1] || ""
    end

    private

    attr_reader :violation
  end
end
