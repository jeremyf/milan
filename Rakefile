require "bundler/gem_tasks"

unless Rake::Task.task_defined?('spec')
  begin
    require 'rspec/core/rake_task'
    RSpec::Core::RakeTask.new(:spec) do |t|
      t.pattern = "./spec/**/*_spec.rb"
      ENV['COVERAGE'] = 'true'
    end
  rescue LoadError
    $stdout.puts "RSpec failed to load; You won't be able to run tests."
  end
end

require 'rubocop/rake_task'
RuboCop::RakeTask.new do |task|
  task.options << "--config=.hound.yml"
end

require 'reek/rake/task'
Reek::Rake::Task.new do |task|
  task.verbose = true
end

require 'flay_task'
FlayTask.new do |task|
  task.verbose = true
  task.threshold = 20
end

task(default: %w(rubocop reek flay spec))
task(release: :default)
