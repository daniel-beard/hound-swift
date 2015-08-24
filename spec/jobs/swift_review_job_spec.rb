require "spec_helper"
require "jobs/swift_review_job"

describe SwiftReviewJob do
  describe ".perform" do
    it "enqueues review job with violations" do
      allow(Resque).to receive("enqueue")
      allow_any_instance_of(SwiftLint::Runner).
        to receive(:execute_swiftlint).and_return(swiftlint_response)

      SwiftReviewJob.perform(
        "filename" => "test.swift",
        "commit_sha" => "123abc",
        "pull_request_number" => "123",
        "patch" => "test",
        "content" => "let number = 1 "
      )

      expect(Resque).to have_received("enqueue").with(
        CompletedFileReviewJob,
        filename: "test.swift",
        commit_sha: "123abc",
        pull_request_number: "123",
        patch: "test",
        violations: [
          { line: 1, message: "Trailing Whitespace Violation (Medium Severity): Line #1 should have no trailing whitespace: current has 1 trailing whitespace characters" }
        ]
      )
    end

    def swiftlint_response
      "<nopath>:1: warning: " \
        "Trailing Whitespace Violation (Medium Severity): " \
        "Line #1 should have no trailing whitespace: " \
        "current has 1 trailing whitespace characters\n"
    end
  end
end
