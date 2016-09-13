class UpdateLaptop
  def run
    say_hi
    run_cmd('brew update')
    run_cmd('brew upgrade')
    run_cmd('brew cleanup')
    mac_update
  end

  def say_hi
    say 'Updating PC'.brown
    say 'Start Update'.brown
    say '_______________________________'.bold
  end

  def run_cmd(name)
    say name.to_s.brown
    say ''
    puts `#{name}`
    say '_______________________________'.bold
  end

  def mac_update
    say ' MacBook Pro Update'.brown
    say ''
    puts `sudo softwareupdate -ia`
    say '_______________________________'.bold
    if agree('Reboot Now? (Yes/No)'.red)
      countdown(5)
      puts `sudo shutdown -r now "Rebooting Now"`.gray.bg_red
    end
  end

    def countdown(n)
      for i in (n).downto(1)
      say "Reboot in #{i} Seconds (Press Ctrl + C to Stop)".red
      say `sleep 1`
    end
  end

end


#Colorized Output
class String
def red;            "\e[31m#{self}\e[0m" end
def gray;           "\e[37m#{self}\e[0m" end
def bg_red;         "\e[41m#{self}\e[0m" end
def bold;           "\e[1m#{self}\e[22m" end
end
