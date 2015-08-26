module SwiftLint
  class SystemCall
    def call(cmd)
      `#{cmd}`
    end
  end
end
