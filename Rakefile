#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

WSMA::Application.load_tasks

desc "Clears the database and loads the sample data"
task :bootstrap => ["cancel_jobs", "db:drop", "db:create", "db:migrate", "db:seed"] do
end

desc "Cancels all Rufus-scheduler jobs, to be used before dropping the database tables"
task :cancel_jobs do
  mode = TimeProvider.in_mock_mode
  TimeProvider.set_mock_mode false
  TimeProvider.unschedule_all_tasks
  TimeProvider.set_mock_mode mode
end