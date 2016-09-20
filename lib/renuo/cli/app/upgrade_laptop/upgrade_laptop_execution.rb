class UpgradeLaptopExecution
  include RunCommand

  def initialize(upgrade_mac_os)
    @upgrade_mac_os = upgrade_mac_os
  end

  def run
    upgrade_apps
    upgrade_mac_os
    upgrade_brew unless mac_os_upgrade_needs_a_restart?
  end

  private

  def upgrade_apps
    setup_mas
    run_command 'mas upgrade'
  end

  def setup_mas
    `which mas || brew install mas`
  end

  def upgrade_mac_os
    @upgrade_mac_os.run
  end

  def mac_os_upgrade_needs_a_restart?
    @upgrade_mac_os.reboot_required?
  end

  def upgrade_brew
    run_command 'brew update'
    run_command 'brew upgrade'
    run_command 'brew cleanup'
  end
end
