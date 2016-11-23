class CreateAwsProject
  def initialize
    unless agree('Did you set up AWSCLI and the IAM profile (renuo-app-setup) yet?')
      abort('You can find setup instructions here: https://redmine.renuo.ch/projects/internal/wiki/Amazon_S3#Setup-AWS-CLI')
    end

    @project_name = ask('Project name (eg: lawoon-frontend): ')
    @project_purpose = ask('Suffix describing purpose (eg: asset): ')
    @redmine_project = ask('Redmine project name for billing (eg: lawoon): ')
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
    say aws_common_setup(@aws_profile, @aws_region, aws_user(branch), @aws_app_group)
    say aws_tag_setup(@aws_profile, aws_user(branch), @redmine_project)
  end

  def print_versioning_setup(branch)
    say aws_versioning_setup(@aws_profile, aws_user(branch))
  end

  def aws_user(branch)
    ([@project_name, branch, @project_purpose] - ['', nil]).join('-')
  end

  def aws_common_setup(profile, region, user, app_group)
    <<-SETUP_COMMANDS
aws --profile #{profile} iam create-user --user-name #{user}
aws --profile #{profile} iam add-user-to-group --user-name #{user} --group-name #{app_group}
aws --profile #{profile} iam create-access-key --user-name #{user}
aws --profile #{profile} s3 mb s3://#{user} --region #{region}
    SETUP_COMMANDS
  end

  def aws_versioning_setup(profile, bucket)
    <<-VERSIONING_COMMANDS
aws --profile #{profile} s3api put-bucket-versioning --bucket #{bucket} --versioning-configuration \
    Status=Enabled
    VERSIONING_COMMANDS
  end

  def aws_tag_setup(profile, bucket, redmine_project)
    <<-VERSIONING_COMMANDS
aws --profile #{profile} s3api put-bucket-tagging --bucket #{bucket} --tagging \
    "TagSet=[{Key=redmine_project,Value=#{redmine_project}}]"
    VERSIONING_COMMANDS
  end
end
