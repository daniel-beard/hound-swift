require "config/redis"
require "resque/tasks"

task "resque:setup" do
  ENV["QUEUE"] = "swift_review"
end

desc "Alias for resque:work (To run workers)"
task "jobs:work" => "resque:work"
