#!/usr/bin/env rake
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require File.expand_path('../config/application', __FILE__)

MoviesCucumbers::Application.load_tasks

desc 'Load Up Movie Db'
task "load_movies" do
  exec "rake db:seed_movi"
end