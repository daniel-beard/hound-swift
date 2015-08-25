module SwiftLint
  class File
    attr_reader :name, :content

    def initialize(name, content)
      @name = name
      @content = content
    end
  end
end
