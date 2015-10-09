#!/usr/bin/env ruby

require 'rubygems'
require 'commander/import'

program :version, '0.0.1'
program :description, 'renuo CLI'

command :setup do |c|
  c.syntax = 'renuo setup [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    # Do something or c.when_called Renuo::Commands::Setup
  end
end

command :config do |c|
  c.syntax = 'renuo config [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |args, options|
    # Do something or c.when_called Renuo::Commands::Config
  end
end

