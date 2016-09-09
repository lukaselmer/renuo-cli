class UpdateLaptop
  def run
    say_hi
    brewupdate
    brewupgrade
    brewcleanup
    mac_update
  end

  def brewupdate
    say 'brew update'
    say ''
    puts `brew update`
    say '-------------------------------'
  end

  def brewupgrade
    say 'brew upgrade'
    say ''
    puts `brew upgrade`
    say '-------------------------------'
  end

  def brewcleanup
    say 'brew cleanup'
    say ''
    puts `brew cleanup`
    say '-------------------------------'
  end

  def mac_update
    say ' MacBook Pro Update'
    say ''
    puts `sudo softwareupdate -iva`
    say '-------------------------------'
  end

  def say_hi
    say 'Updating PC'
    say 'Start Update'
    say '_______________________________'
  end
end
