class InitUpgradeMas
  include RunCommand

  def run
    setup_mas
    return if logged_out? && !signin_to_app_store
    upgrade_apps
  end

  def setup_mas
    `which mas || brew install mas`
  end

  def logged_out?
    `mas account`.include? 'Not signed in'
  end

  def signin_to_app_store
    say "Sign in to AppStore\nPlease Enter AppleID E-Mail".yellow
    apple_id = STDIN.gets
    system "mas signin #{apple_id}"
  end

  def upgrade_apps
    run_command 'mas upgrade'
  end
end
