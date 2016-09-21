class UpgradeLaptopExecution
  include RunCommand

  def initialize(upgrade_mac_os, init_upgrade_mas)
    @upgrade_mac_os = upgrade_mac_os
    @init_upgrade_mas = init_upgrade_mas
  end

  def run
    upgrade_mas
    upgrade_mac_os
    upgrade_brew unless mac_os_upgrade_needs_a_restart?
  end

  private

  def upgrade_mas
    @init_upgrade_mas.run
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
