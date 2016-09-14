require_relative 'upgrade_mac_os.rb'
class UpdateLaptop
  include UpgradeMacOS

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

  def upgrade_brew
    run_command 'brew update'
    run_command 'brew upgrade'
    run_command 'brew cleanup'
  end
end
