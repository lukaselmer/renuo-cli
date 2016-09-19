class UpgradeMacOS
  include RunCommand

  def run
    find_software_upgrades
    return unless upgrade_available?

    return if reboot_required_and_not_agreed_to?

    execute_upgrade
  end

  private

  def find_software_upgrades
    say "\nUpdating  macOS.\nFinding available software (this may take a while)".yellow

    @output = `softwareupdate --list 2>&1`
    say @output
  end

  def upgrade_available?
    @output.include? 'Software Update found'
  end

  def reboot_required_and_not_agreed_to?
    reboot_required? && !agree_for_reboot?
  end

  def reboot_required?
    @output.include? '[restart]'
  end

  def agree_for_reboot?
    agree 'Your Mac needs to be rebooted, Still continue? (Yes / No)'
  end

  def execute_upgrade
    run_command 'softwareupdate --install --all'
    reboot if reboot_required?
  end

  def reboot
    say 'Rebooting Now'.white.on_red
    puts `osascript -e 'tell app "System Events" to restart'`
  end
end
