class UpdateLaptop
  def run
    say_hi
    run_cmd('brew update')
    run_cmd('brew upgrade')
    run_cmd('brew cleanup')
    mac_update
  end

  def say_hi
    say 'Updating PC'.yellow
    say 'Start Update'.yellow
    say '_______________________________'.bold
  end

  def run_cmd(name)
    say name.to_s.yellow
    say ''
    puts `#{name}`
    say '_______________________________'.bold
  end

  def mac_update
    say ' MacBook Pro Update'.yellow
    say ''
    puts `sudo softwareupdate -ia`
    say '_______________________________'.bold
    return unless agree('Reboot Now? (Yes/No)'.red)
    countdown(5)
    say 'Rebooting Now'.white.on_red
    puts `sudo shutdown -r now "Rebooting Now"`
  end

  def countdown(n)
    n.downto(1) do |i|
      say "Reboot in #{i} Seconds (Press Ctrl + C to Stop)".red
      say `sleep 1`
    end
  end
end
