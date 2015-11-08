require 'renuo/cli/version'
require 'rubygems'
require 'commander/import'
require 'renuo/cli/app/name_display'
require 'renuo/cli/app/local_storage'

program :version, '0.0.1'
program :description, 'renuo CLI'

command 'display-name'.to_sym do |c|
  c.syntax = 'renuo display-name [options]'
  c.summary = 'displays the name of a customer'
  c.description = ''
  c.example 'description', 'command example'
  c.option '--delete', 'Deletes the current name'
  c.action do |args, _options|
    NameDisplay.new.display_name(args)
  end
end

command :config do |c|
  c.syntax = 'renuo config [options]'
  c.summary = ''
  c.description = ''
  c.example 'description', 'command example'
  c.option '--some-switch', 'Some switch that does something'
  c.action do |_args, _options|
    key = ask('API Key?') { |q| q.echo = '*' }
    LocalStorage.new.store(:api_key, key)
    say('stored the api key')
  end
end
