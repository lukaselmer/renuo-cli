require_relative 'upgrade_laptop/run_command'
require_relative 'upgrade_laptop/upgrade_laptop_execution'
require_relative 'upgrade_laptop/upgrade_mac_os'
require_relative 'upgrade_laptop/init_upgrade_mas'

class UpgradeLaptop
  def run
    say_hi
    run_upgrade
  end

  private

  def say_hi
    say 'Start Update'
  end

  def run_upgrade
    UpgradeLaptopExecution.new(UpgradeMacOS.new, InitUpgradeMas.new).run
  end
end
