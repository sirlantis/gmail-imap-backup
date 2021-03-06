#!/usr/bin/env ruby

require 'rubygems'
require File.join(File.dirname(__FILE__), 'lib', 'backup.rb')

config_file = GmailBackup::YAMLFile.new('config.yml')
config = config_file.read

destination_root = config['destination_root']
raise "No destination" unless destination_root

statepath = File.join(destination_root, 'state.')

Lockfile.new statepath+'lock', :retries => 2 do
  state_file = GmailBackup::YAMLFile.new(statepath+'yml')
  todo_file = GmailBackup::YAMLFile.new(statepath+'todo.yml')
  GmailBackup::IMAPBackup.new(config, state_file, todo_file).run
end
