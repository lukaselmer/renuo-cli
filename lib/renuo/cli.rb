require 'renuo/cli/version'
require 'rubygems'
require 'renuo/cli/app/name_display'
require 'renuo/cli/app/local_storage'
require 'renuo/cli/app/migrate_to_github'
require 'renuo/cli/app/list_large_git_files'
require 'renuo/cli/app/generate_password'
require 'renuo/cli/app/application_setup_auto_config'
require 'renuo/cli/app/import_redmine_issues'

module Renuo
  class CLI
    def start
      require 'commander/import'
      program :version, Renuo::Cli::VERSION
      program :description, 'renuo CLI'

      command 'display-name'.to_sym do |c|
        c.syntax = 'renuo display-name [options]'
        c.summary = 'Sets the name of a customer on the Renuo dashboard'
        c.description = 'Sets the name of a customer on the Renuo dashboard'
        c.example 'Display "Peter Muster" on the dashboard', 'renuo display-name "Peter Muster"'
        c.example 'Remove the current name from the dashboard', 'renuo display-name --delete'
        c.option '--delete', 'Deletes the current name'
        c.action do |args, options|
          NameDisplay.new.run(args, options)
        end
      end

      command :config do |c|
        c.syntax = 'renuo config [options]'
        c.summary = 'Setup the config (API keys)'
        c.description = 'Setup the config (API keys)'
        c.action do
          key = ask('API Key?') { |q| q.echo = '*' }
          LocalStorage.new.store(:api_key, key)
          say('stored the api key')
        end
      end

      command 'migrate-to-github' do |c|
        c.syntax = 'renuo migrate-to-github [project]'
        c.summary = 'A guide how to migrate from gitlab to github'
        c.description = 'A guide how to migrate from gitlab to github'
        c.example 'migrate the renuo-cli project', 'renuo migrate-to-github renuo-cli'
        c.action do |args, _options|
          MigrateToGithub.new(args.first).run
        end
      end

      command 'list-large-git-files' do |c|
        c.syntax = 'renuo list-large-git-files'
        c.summary = 'Lists the 5 largest files in a git repository. Warning: must be a bare checkout of the repo!'
        c.description = "Lists the 5 largest files in a git repository.\nWarning: must be a bare checkout of the repo!"
        c.example 'list the 5 largest git files of github.com/renuo/renuo-cli',
                  'git clone --bare git@github.com:renuo/renuo-cli.git && '\
                  'cd renuo-cli.git && renuo list-large-git-files'
        c.action do
          ListLargeGitFiles.new.run
        end
      end

      command 'generate-password' do |c|
        c.syntax = 'renuo generate-password'
        c.summary = 'Generates a phrase of random 0-9a-zA-Z characters. Choose a substring of it as a new password.'
        c.description = 'Generates a phrase of random 0-9a-zA-Z characters. Choose a substring of it as a new password.'
        c.example 'renuo generate-password', 'generates a random password'
        c.action do
          GeneratePassword.new.run
        end
      end

      command 'application-setup-auto-config' do |c|
        c.syntax = 'renuo application-setup-auto-config'
        c.summary = 'Sets up the application setup using the default config'
        c.description = 'Generates a phrase of random 0-9a-zA-Z characters. Choose a substring of it as a new password.'
        c.example 'renuo application-setup-auto-config', 'applies the default config'
        c.action do
          ApplicationSetupAutoConfig.new.run
        end
      end

      command 'import-redmine-issues' do |c|
        c.syntax = 'renuo import-redmine-issues [csv_path]'
        c.summary = 'Import Redmine Issues from CSV'
        c.description = 'Automatically create redmine issues from a CSV file (format project_id,subject,description,estimated_hours)'
        c.example 'Create Redmine issues from downloaded CSV file', 'renuo import-redmine-issues ~/Downloads/issues.csv'
        c.action do |args, _options|
          api_key = ask('Redmine API Key: ') { |q| q.echo = '*' }
          ImportRedmineIssues.new(api_key).run(args.first)
        end
      end
    end
  end
end
