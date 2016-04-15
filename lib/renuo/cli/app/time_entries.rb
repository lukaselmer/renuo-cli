require 'date'
require 'httparty'
require 'uri'
require 'optparse'
require 'colorize'

class TimeEntries
  def initialize(arguments, options)
    @local_storage = LocalStorage.new
    @options = options
    @arguments = arguments
    setup_redmine_api_key unless @local_storage.load(:redmine_api_key)
    setup_toggle_api_key unless @local_storage.load(:toggle_api_key)
  end

  def run
    weeks = set_weeks_by_arguments
    weeks.each do |i|
      i = i.to_i unless i.is_a? Numeric
      next if i == 0
      get_report_for_week(Date.today.year, i)
      say "\n"
    end
  end

  class Statistics
    def initialize(options)
      @options = options
      @toggl_total = 0
      @redmine_total = 0
    end

    def add_redmine_entry(entry)
      @redmine_total += entry[:hours]
    end

    def add_toggl_hours(hours)
      @toggl_total += hours
    end

    def add_redmine_hours(hours)
      @redmine_total += hours
    end

    def print
      difference = @redmine_total - @toggl_total
      status_color = difference != 0.0 ? :red : :green
      if @options.verbose
        say ''
        say "Total Toggl: #{@toggl_total}".colorize(status_color)
        say "Total Redmine: #{@redmine_total}".colorize(status_color)
      else
        say "Total: #{@redmine_total}".colorize(status_color)
        say "Difference: #{difference}".colorize(status_color) unless difference == 0.0
      end
    end
  end

  private

  def set_weeks_by_arguments
    return [Date.today.cweek] if @options.current
    return ((Date.today.cweek - 2)..(Date.today.cweek - 0)) unless @arguments[0]
    return @arguments[0].split ',' if @arguments[0]
  end

  def get_report_for_week(year, week)
    date_monday = Date.commercial(year, week, 1)
    date_sunday = Date.commercial(year, week, 7)
    statistics = Statistics.new(@options)

    entries_redmine = parse_redmine_json_to_hash(date_monday, date_sunday)
    entries_toggl = parse_toggl_json_to_hash(date_monday, date_sunday)
    toggl_detail_link = "https://toggl.com/app/reports/detailed/#{entries_toggl.first['wid']}/from/#{date_monday.strftime('%Y-%m-%d')}/to/#{date_sunday.strftime('%Y-%m-%d')}"

    print_report_header(date_monday, date_sunday, toggl_detail_link, entries_toggl.first['uid'])
    entries_toggl.each do |toggl_entry|
      key = toggl_entry_description(toggl_entry)
      redmine_entry = entries_redmine[key]
      redmine_id = toggl_entry['description'].slice(/\d* /).strip
      toggl_date = Date.parse(toggl_entry['start'])
      toggl_hours = (toggl_entry['duration'] / 3600.0).round(2)
      statistics.add_toggl_hours(toggl_hours)
      entry_title = "#{toggl_date.strftime('%Y-%m-%d')} Entry '#{toggl_entry['description']}'"
      if redmine_entry.nil?
        print_error_not_found_in_redmine(entry_title, key, toggl_date, toggl_hours)
      else
        statistics.add_redmine_entry(redmine_entry)
        if redmine_entry[:hours] != toggl_hours
          print_error_time_difference(entry_title, redmine_entry, toggl_detail_link, toggl_entry, toggl_hours)
        else
          if redmine_entry[:issue].to_s != redmine_id.to_s
            print_error_issue_difference(entry_title, redmine_entry, redmine_id, toggl_detail_link, toggl_entry)
          else
            if @options.verbose
              print_ok(entry_title, redmine_entry, toggl_detail_link, toggl_entry)
            end
          end
        end
      end
      entries_redmine.delete(key)
    end
    if entries_redmine.count > 0
      statistics.add_redmine_hours(entries_redmine.map { |_i, v| v[:hours] }.reduce(:+))
      print_entries_only_in_redmine(entries_redmine)
    end
    statistics.print
  end

  def toggl_entry_description(toggl_entry)
    "#{toggl_entry['id']}: #{toggl_entry['description'].scan(/\d* (.*)/).join('')}"
  end

  def print_ok(entry_title, redmine_entry, toggl_detail_link, toggl_entry)
    say "- [OK] #{entry_title} found: #{redmine_entry[:id]}".colorize(:green)
    print_details(redmine_entry, toggl_detail_link, toggl_entry)
  end

  def print_error_issue_difference(entry_title, redmine_entry, redmine_id, toggl_detail_link, toggl_entry)
    say "-[ERROR] #{entry_title} found: #{redmine_entry[:id]} but has different issue: #{redmine_id} (toggl) / #{redmine_entry[:issue]} (redmine)".colorize(:red)
    print_details(redmine_entry, toggl_detail_link, toggl_entry)
  end

  def print_error_time_difference(entry_title, redmine_entry, toggl_detail_link, toggl_entry, toggl_hours)
    say "-[ERROR] #{entry_title} found: #{redmine_entry[:id]} but has difference in time: #{toggl_hours} (toggl) / #{redmine_entry[:hours]} (redmine)".colorize(:red)
    print_details(redmine_entry, toggl_detail_link, toggl_entry)
  end

  def print_error_not_found_in_redmine(entry_title, key, toggl_date, toggl_hours)
    puts "-[ERROR] #{entry_title} (#{toggl_hours}h) not found"
    puts "  - https://redmine.renuo.ch/time_entries?user_id=me&spent_on=#{toggl_date.strftime('%Y-%m-%d')}"
    puts "  - looking for #{key}"
  end

  def print_details(redmine_entry, toggl_detail_link, toggl_entry)
    say "  - https://redmine.renuo.ch/time_entries/#{redmine_entry[:id]}/edit"
    say "  - #{toggl_detail_link}/description/#{URI.escape(toggl_entry['description'])}/billable/both"
  end

  def print_report_header(date_monday, date_sunday, base_link, uid)
    say "Report #{date_monday.strftime('%Y-%m-%d')} - #{date_sunday.strftime('%Y-%m-%d')}".colorize(:yellow).underline
    say "(#{base_link}/users/#{uid}/billable/both)"
  end

  def print_entries_only_in_redmine(entries_redmine)
    say 'Has more entries in redmine:'.colorize(:light_blue)
    entries_redmine.each do |entry_redmine|
      key, value = entry_redmine
      say "- https://redmine.renuo.ch/time_entries/#{value[:id]}/edit".colorize(:light_blue)
    end
  end

  def parse_toggl_json_to_hash(date_monday, date_sunday)
    toggl_auth = { username: @local_storage.load(:toggle_api_key), password: 'api_token' }
    toggl_url = "https://www.toggl.com/api/v8/time_entries?start_date=#{url_encoded_iso8601(date_monday)}&end_date=#{url_encoded_iso8601(date_sunday)}"
    parse_json(toggl_url, toggl_auth)
  end

  def parse_redmine_json_to_hash(date_monday, date_sunday)
    redmine_auth = { username: @local_storage.load(:redmine_api_key), password: 'yolo' }
    redmine_base_url = 'https://redmine.renuo.ch/time_entries.json?user_id=me'
    redmine_url = "#{redmine_base_url}&spent_on=><#{date_monday.strftime('%Y-%m-%d')}|#{date_sunday.strftime('%Y-%m-%d')}&limit=100"
    entries_redmine = {}
    parse_json(redmine_url, redmine_auth)['time_entries'].each do |rme|
      redmine_description_without_date = rme['comments'].scan(/(\d*: .*) : : /).join('')
      entries_redmine[redmine_description_without_date.to_s] = {
        id: rme['id'],
        issue: rme['issue']['id'],
        hours: rme['hours'],
        description: rme['comments']
      }
    end
    entries_redmine
  end

  def url_encoded_iso8601(date)
    date.strftime('%Y-%m-%dT%H:%M:%S%:z').gsub(/[:+]/, '+' => '%2B', ':' => '%3A')
  end

  def parse_json(url, auth)
    response = HTTParty.get(url, basic_auth: auth)
    response.parsed_response
  end

  def setup_redmine_api_key
    redmine_api_key = ask 'What is your Redmine API-Key? (https://redmine.renuo.ch/my/account)'
    @local_storage.store(:redmine_api_key, redmine_api_key)
  end

  def setup_toggle_api_key
    toggle_api_key = ask 'What is your Toggle API-Key? (https://toggl.com/app/profile)'
    @local_storage.store(:toggle_api_key, toggle_api_key)
  end
end
