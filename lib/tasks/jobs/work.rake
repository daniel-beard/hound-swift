require "config/redis"
require "resque/tasks"
require "dotenv/tasks"

task "resque:setup" do
  ENV["QUEUE"] = "swift_review"
end

desc "Alias for resque:work (To run workers)"
task "jobs:work" => [:dotenv, "resque:work"]
