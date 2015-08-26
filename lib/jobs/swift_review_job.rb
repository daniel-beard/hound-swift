require "resque"
require "awesome_print"

require "jobs/completed_file_review_job"
require "swift_lint"
require "swift_lint/file"
require "swift_lint/runner"

class SwiftReviewJob
  @queue = :swift_review

  def self.perform(attributes)
    # filename
    # commit_sha
    # pull_request_number (pass-through)
    # patch (pass-through)
    # content
    # config

    file = file_for(attributes: attributes)
    violations = violations_for(file: file)

    completed_file_review(
      file: file,
      attributes: attributes,
      violations: violations,
    )
  end

  def self.completed_file_review(file:, attributes:, violations:)
    Resque.enqueue(
      CompletedFileReviewJob,
      filename: file.name,
      commit_sha: attributes.fetch("commit_sha"),
      pull_request_number: attributes.fetch("pull_request_number"),
      patch: attributes.fetch("patch"),
      violations: violations,
    )
  end

  def self.violations_for(file:)
    swift_lint_runner = SwiftLint::Runner.new
    swift_lint_runner.violations_for(file)
  end

  def self.file_for(attributes:)
    SwiftLint::File.new(
      attributes.fetch("filename"),
      attributes.fetch("content"),
    )
  end
end
