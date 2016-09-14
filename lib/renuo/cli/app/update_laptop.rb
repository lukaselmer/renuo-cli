class UpdateLaptop
  def run
    say_hi
    run_command('brew update')
    run_command('brew upgrade')
    run_command('brew cleanup')
    run_command_and_say('sudo softwareupdate -ia', ' MacBook Pro Update')
    reboot
  end

  def say_hi
    say 'Updating  Mac'
    say 'Start Update'
    say '_______________________________'.bold
  end

  def run_command_and_say(command, message)
    say message.to_s.yellow
    say ''
    puts `#{command}`
    say '_______________________________'.bold
  end

  def run_command(command)
    run_command_and_say command, command
  end

  def reboot
    say 'Rebooting in 60 Seconds'.white.on_red
    puts `osascript -e 'tell app "loginwindow" to «event aevtrrst»'`
  end
end
