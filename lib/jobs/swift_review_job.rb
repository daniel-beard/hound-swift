require "resque"

require "swift_lint"
require "swift_lint/runner"
require "jobs/completed_file_review_job"

class SwiftReviewJob
  @queue = :swift_review

  def self.perform(attributes)
    # filename
    # commit_sha
    # pull_request_number (pass-through)
    # patch (pass-through)
    # content
    # config

    violations = violations_for_content(attributes["content"])

    Resque.enqueue(
      CompletedFileReviewJob,
      filename: attributes.fetch("filename"),
      commit_sha: attributes.fetch("commit_sha"),
      pull_request_number: attributes.fetch("pull_request_number"),
      patch: attributes.fetch("patch"),
      violations: violations
    )
  end

  def self.violations_for_content(content)
    swift_lint_runner = SwiftLint::Runner.new
    swift_violations = swift_lint_runner.violations_for(content)

    violations = swift_violations.map do |violation|
      { line: violation.line_number, message: violation.message }
    end
  end
end
