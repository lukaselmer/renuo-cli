module RunCommand
  def run_command(command)
    say "\n#{command.yellow}"
    system command
  end
end
