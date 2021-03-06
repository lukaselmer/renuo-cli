class CreateAwsProject
  def initialize
    unless agree('Did you set up AWSCLI and the IAM profile (renuo-app-setup) yet?')
      abort('You can find setup instructions here: https://redmine.renuo.ch/projects/internal/wiki/Amazon_S3#Setup-AWS-CLI')
    end

    @project_name = ask('Project name (eg: renuo-cli): ') { |q| q.validate = /.+/ }
    @project_purpose = ask('Suffix describing purpose (eg: assets): ') { |q| q.default = 'none' }
    @project_purpose = nil if @project_purpose.empty? || @project_purpose == 'none'
    @redmine_project = ask('Redmine project name for billing (eg: internal): ') { |q| q.validate = /.+/ }
    @aws_profile = 'renuo-app-setup'
    @aws_region = ask('AWS bucket region: ') { |q| q.default = 'eu-central-1' }
    @aws_app_group = 'renuo-apps-v2'
  end

  def run
    say "\n# master:\n"
    print_common_setup 'master'
    print_versioning_setup 'master'

    say "\n# develop:\n"
    print_common_setup 'develop'

    say "\n# testing:\n"
    print_common_setup 'testing'
  end

  private

  def print_common_setup(branch)
    say common_setup(@aws_profile, @aws_region, aws_user(branch), @aws_app_group)
    say tag_setup(@aws_profile, aws_user(branch), @redmine_project)
  end

  def print_versioning_setup(branch)
    say versioning_setup(@aws_profile, aws_user(branch))
  end

  def aws_user(branch)
    [@project_name, branch, @project_purpose].compact.join('-')
  end

  def common_setup(profile, region, user, app_group)
    <<-SETUP_COMMANDS
      aws --profile #{profile} iam create-user --user-name #{user}
      aws --profile #{profile} iam add-user-to-group --user-name #{user} --group-name #{app_group}
      aws --profile #{profile} iam create-access-key --user-name #{user}
      aws --profile #{profile} s3 mb s3://#{user} --region #{region}
    SETUP_COMMANDS
  end

  def versioning_setup(profile, bucket)
    <<-VERSIONING_COMMANDS
      aws --profile #{profile} s3api put-bucket-versioning --bucket #{bucket} --versioning-configuration Status=Enabled
    VERSIONING_COMMANDS
  end

  def tag_setup(profile, bucket, redmine_project)
    <<-TAGGING_COMMANDS
      aws --profile #{profile} s3api put-bucket-tagging --bucket #{bucket} --tagging "TagSet=[{Key=redmine_project,Value=#{redmine_project}}]"
    TAGGING_COMMANDS
  end
end
