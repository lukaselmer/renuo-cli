class InitUpgradeMas
  include RunCommand

  def run
    setup_mas
    return if logged_out? && !signin_to_app_store
    upgrade_apps
    init_required_apps
    _required_apps unless _apps_to_install.empty?
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

  def init_required_apps
    @xcode = 497_799_835
    keynote = 409_183_694
    pages = 409_201_541
    numbers = 409_203_825
    text_wrangler = 404_010_395
    slack = 803_453_959
    onedrive = 823_766_827
    @required_apps = [@xcode, keynote, pages, numbers, text_wrangler, slack, onedrive, 897118787]
  end

  def _required_apps
    _apps_to_install.each  do |app|
      run_command "mas install #{app}"
      say_link app if `mas install #{app}` == ''
    end
    run_command 'sudo xcodebuild -license' if _apps_to_install.include? @xcode
  end

  def say_link(app)
    say 'Installation failed'.red
    say "Please download macappstores://itunes.apple.com/ch/app/id#{app}".red
  end

  def _apps_to_install
    output = `mas list`.split "\n"
    output.map! { |x| x.split(' ').first.to_i }
    @apps_to_install = @required_apps - output
  end
end
