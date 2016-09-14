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
    say 'Updating  macOS (this may take a while)'.yellow

    output = `softwareupdate --list 2>&1`
    puts output

    return unless update_available output

    if reboot_required output
      return unless ask_for_update
    end

    run_command 'softwareupdate --install --all'
    reboot if reboot_required output
  end

  def reboot_required(output)
    output.include? '[restart]'
  end

  def update_available(output)
    !(output.include? 'No new software available')
  end

  def ask_for_update
    agree('Your Mac needs to be rebooted, Still continue? (Yes / No)')
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
    system command
  end
end
