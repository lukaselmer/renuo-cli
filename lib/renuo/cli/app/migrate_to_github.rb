class MigrateToGithub
  def initialize(project_name)
    @project_name = project_name
    @pwd = `pwd`.strip
  end

  def run
    return stop unless check_requirements
    return stop unless check_pwd

    run_tasks
  end

  private

  def task(description)
    say("=> #{description}")
  end

  def run_tasks
    transfer_git
    update_readme
    repo_settings
    check_deploy
    rename_repo
    replace_other_old_links
    setup_gemnasium
    setup_ci
    congrats
  end

  def check_requirements
    say('Please ensure that hub is installed (brew install hub) and connected to your account')
    agree('Ready?')
  end

  def check_pwd
    say("Project to transfer is called '#{@project_name}'. For the transfer, we will need these temporary directories")
    say("* #{@pwd}/#{@project_name}")
    say("* #{@pwd}/#{@project_name}.git")
    say('If you want to use different directories, cd to a another directory, and run the command again.')
    say("E.g.: cd ~/tmp ; mkdir transfer ; cd transfer ; renuo migrate-to-github #{@project_name}")
    agree('Is that ok?')
  end

  def transfer_git
    puts `git clone --mirror git@git.renuo.ch:renuo/#{@project_name}.git`
    puts `cd #{@project_name}.git && hub create -p renuo/#{@project_name}`
    puts `cd #{@project_name}.git && git push --mirror git@github.com:renuo/#{@project_name}.git`
    `rm -rf #{@project_name}.git`
  end

  def update_readme
    agree('Let us update the README.md now. Ready?')

    puts `git clone git@github.com:renuo/#{@project_name}.git`
    puts `cd #{@project_name} && git fetch --all && git checkout develop && git pull && git flow init -d`
    File.write("#{@project_name}/README.md", File.read("#{@project_name}/README.md").gsub('git.renuo.ch', 'github.com'))

    update_readme_loop

    puts `cd #{@project_name} && git commit -m 'migrate to github' && git push --set-upstream origin develop`
    `rm -rf #{@project_name}`
  end

  def update_readme_loop
    loop do
      puts `cd #{@project_name} && git add . && git status && git diff --staged`
      break if agree('Does this look ok?')
      ask("Please change it manually in #{@pwd}/#{@project_name}. Hit enter when you are done.")
    end
  end

  def repo_settings
    general_repo_settings
    repo_collaborators
    repo_branches
    copy_hooks
  end

  def general_repo_settings
    say('The repo settings are next')
    task('Remove the features "Wikis" and "Issues"')
    task('Close the tab when you are done')
    agree('The browser will open automatically. Ready?')
    `open https://github.com/renuo/#{@project_name}/settings`
  end

  def repo_collaborators
    task("Next, assign Renuo-Team 'renuo' to project and grant 'write' permissions")
    agree('Ready?')
    `open https://github.com/renuo/#{@project_name}/settings/collaboration`
  end

  def repo_branches
    task('Choose develop as default branch')
    task('Protect branches master and develop')
    agree('Ready?')
    `open https://github.com/renuo/#{@project_name}/settings/branches`
  end

  def copy_hooks
    task('Copy the hooks from gitlab to github. We will open two tabs this time (gitlab and github)')
    agree('Ready?')
    `open https://github.com/renuo/#{@project_name}/settings/hooks`
    `open https://git.renuo.ch/renuo/#{@project_name}/hooks`
  end

  def check_deploy
    task('Check the deployment scripts for the correct repository')
    agree('Ready?')
    `open https://deploy.renuo.ch/deployment_configs`
    task('Now login to the deployment server as www-data, and change the remotes. E.g.')
    cd = "cd deployments/#{@project_name}"
    say("#{cd}-master && git remote set-url origin git@github.com:renuo/#{@project_name}.git && cd ../..")
    say("#{cd}-develop && git remote set-url origin git@github.com:renuo/#{@project_name}.git && cd ../..")
    say("#{cd}-testing && git remote set-url origin git@github.com:renuo/#{@project_name}.git && cd ../..")
    agree('Ready?')
  end

  def rename_repo
    task("Almost done. Rename the old repo to zzz-old-#{@project_name}")
    say('   * Project name')
    say('   * Path')
    agree('Ready?')
    `open https://git.renuo.ch/renuo/#{@project_name}/edit`
  end

  def replace_other_old_links
    say('Now let\'s replace other old links in the repo!')
    agree('Ready?')
    `open https://github.com/renuo/#{@project_name}/search?q=git.renuo.ch`
    task('Replace all those links!')
    agree('Ready?')
    task('Now let\'s replace other old links in the wiki!')
    `open https://redmine.renuo.ch/search?q=git.renuo.ch/renuo/#{@project_name}&wiki_pages=1&attachments=0&options=0`
    task('Replace all those links!')
    agree('Ready?')
  end

  def setup_gemnasium
    say('Now the security monitoring: Gemnasium')
    task('Go to https://gemnasium.com/dashboard and add the new project via GitHub')
    task("Add new project --> Hosted on GitHub --> Renuo --> Check #{@project_name} and click submit")
    agree('Ready?')
    `open https://gemnasium.com/dashboard`
  end

  def setup_ci
    say('One last thing: CI')
    say('Find your CI script on the old CI:')
    task('Click on <project> --> Settings --> preview')
    agree('Ready?')
    `open https://ci.renuo.ch/`
    say("Enable TravisCI for #{@project_name}")
    agree('Ready?')
    `open https://magnum.travis-ci.com/profile/renuo`
  end

  def congrats
    agree("That's it! Congrats!!")
    agree('I hope you enjoy Github and TravisCI!')
    agree('Cheers!')
  end

  def stop
    say('Command aborted.')
  end
end
