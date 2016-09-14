class UpdateLaptop
  def run
    setup_mas

    say_hi

    upgrade_apps
    upgrade_mac_os
    upgrade_brew
  end

  def setup_mas
    puts `which mas &> /dev/null  || brew install mas`
  end

  def say_hi
    say 'Start Update'
  end

  def upgrade_apps
    run_command 'mas upgrade'
  end

  def upgrade_mac_os
    say 'Updating  macOS'.yellow
    return unless update_available
    reboot_required_to_update = reboot_required
    if reboot_required_to_update
      return unless agree('Your Mac needs to be rebooted, Still continue? (Yes / No)')
    end
    run_command 'softwareupdate --install --all'
    return unless reboot_required_to_update
    reboot
  end

  def reboot_required
    output = `softwareupdate --list 2>&1`
    puts output
    !(output.include? '[restart]')
  end

  def update_available
    output = `softwareupdate --list 2>&1`
    puts output
    !(output.include? 'No new software available')
  end

  def reboot
    say 'Rebooting in 60 Seconds'.white.on_red
    puts `osascript -e 'tell app "loginwindow" to «event aevtrrst»'`
  end

  def upgrade_brew
    run_command 'brew update'
    run_command 'brew upgrade'
    run_command 'brew cleanup'
  end

  def run_command(command)
    say command.to_s.yellow
    say ''
    puts `#{command}`
  end
end
