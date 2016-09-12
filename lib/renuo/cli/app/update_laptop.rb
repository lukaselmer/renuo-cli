class UpdateLaptop
  def run
    say_hi
    run_cmd('brew update')
    run_cmd('brew upgrade')
    run_cmd('brew cleanup')
    mac_update
  end

  def say_hi
    say 'Updating PC'
    say 'Start Update'
    say '_______________________________'
  end

  def run_cmd(name)
    say name.to_s
    say ''
    puts `#{name}`
    say '-------------------------------'
  end

  def mac_update
    say ' MacBook Pro Update'
    say ''
    puts `sudo softwareupdate -iva`
    say '-------------------------------'
    agree('Rebooting Now?')
    puts `sudo shutdown -r now "Rebooting Now"`
  end
end
