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

namespace :commitment do
  task :configure_test_for_code_coverage do
    ENV['COVERAGE'] = 'true'
  end
  task :code_coverage do
    require 'json'
    $stdout.puts "Checking code_coverage"
    lastrun_filename = File.expand_path('../coverage/.last_run.json', __FILE__)
    if File.exist?(lastrun_filename)
      coverage_percentage = JSON.parse(File.read(lastrun_filename)).fetch('result').fetch('covered_percent').to_i
      if coverage_percentage < 100
        abort("ERROR: Code Coverage Goal Not Met:\n\t#{coverage_percentage}%\tExpected\n\t100%\tActual")
      else
        $stdout.puts "Code Coverage Goal Met (100%)"
      end
    else
      abort "Expected #{lastrun_filename} to exist for code coverage"
    end
  end
end

task(default: [:rubocop, :reek, :flay, 'commitment:configure_test_for_code_coverage', :spec, 'commitment:code_coverage'])
task(release: :default)
