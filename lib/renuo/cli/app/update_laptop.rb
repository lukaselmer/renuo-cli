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
    say '_______________________________'
  end

  def mac_update
    say ' MacBook Pro Update'
    say ''
    puts `sudo softwareupdate -ia`
    say '_______________________________'
    return unless agree('Reboot Now? (Yes/No)')
    countdown(5)
    say 'Rebooting Now'
    puts `sudo shutdown -r now "Rebooting Now"`
  end

  def countdown(n)
    n.downto(1) do |i|
      say "Reboot in #{i} Seconds (Press Ctrl + C to Stop)"
      say `sleep 1`
    end
  end
end
