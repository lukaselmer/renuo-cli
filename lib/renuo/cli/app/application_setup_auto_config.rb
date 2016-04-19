require 'renuo/cli/app/services/markdown_parser_service'
require 'net/http'

# see https://www.gitbook.com/book/renuo/rails-application-setup-guide/edit#/edit/master/templates/auto_copy_files.md

class ApplicationSetupAutoConfig
  def run
    url = 'https://raw.githubusercontent.com/renuo/rails-application-setup-guide/master/templates/auto_copy_files.md'
    data = Net::HTTP.get(URI(url))
    files = MarkdownParserService.new.parse_markdown(data)
    files.each { |file, hint| handle_file(file, hint) }
  end

  def handle_file(file, hint)
    base_url = 'https://raw.githubusercontent.com/renuo/rails-application-setup-guide/master/templates/'
    if agree("Overwrite #{file}?#{" Hint: #{hint})" if hint}")
      `curl #{base_url}#{file} > #{file}`
    else
      puts "Skipping file #{base_url}#{file}"
    end
  end
end
