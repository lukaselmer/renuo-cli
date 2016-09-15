module UpgradeMacOS
  def upgrade_mac_os
    say 'Updating  macOS. Finding available software (this may take a while)'.yellow

    output = `softwareupdate --list 2>&1`
    puts output

    return unless update_available output

    if reboot_required output
      return unless agree_for_reboot
    end

    run_command 'softwareupdate --install --all'
    reboot if reboot_required output
  end

  private

  def update_available(output)
    !(output.include? 'No new software available')
  end

  def reboot_required(output)
    output.include? '[restart]'
  end

  def agree_for_reboot
    agree('Your Mac needs to be rebooted, Still continue? (Yes / No)')
  end

  def reboot
    say 'Rebooting Now'.white.on_red
    puts `osascript -e 'tell app "System Events" to restart'`
    true
  end

  def run_command(command)
    say command.to_s.yellow
    system command
  end
end
