require 'net/http'
require 'json'
require 'csv'

class ImportRedmineIssues
  def initialize(redmine_api_key)
    @redmine_api_key = redmine_api_key
    @html_uri = URI('https://redmine.renuo.ch/issues')
    @json_uri = URI('https://redmine.renuo.ch/issues.json')
  end

  def run(csv_path)
    https = Net::HTTP.new(@json_uri.host, @json_uri.port)
    https.use_ssl = true

    parsed_issues(csv_path).each do |issue|
      request = build_request(issue)
      response = https.request(request)
      handle_response(response)
    end

  rescue SocketError => details
    say "Are you connected to the internet? SocketError: #{details}"
    exit 1
  end

  private

  def build_request(issue)
    request = Net::HTTP::Post.new(@json_uri)
    request.add_field('Content-Type', 'application/json')
    request.add_field('X-Redmine-API-Key', @redmine_api_key)
    request.body = JSON.generate(issue)
    request
  end

  def handle_response(response)
    if response.is_a? Net::HTTPCreated
      issue_id = JSON.parse(response.body)['issue']['id']
      issue_url = URI.join(@html_uri, issue_id.to_s)
      say issue_url
    else
      say "#{response.code} #{response.message}"
    end
  end

  def parsed_issues(csv_path)
    issues = []

    CSV.foreach(csv_path) do |row|
      issues << { 'issue' => parse_issue(row) }
    end

    issues
  end

  def parse_issue(csv_row)
    {
      'project_id' => csv_row[0],
      'subject' => csv_row[1],
      'description' => csv_row[2],
      'estimated_hours' => csv_row[3]
    }
  end
end
