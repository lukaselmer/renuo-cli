require 'redcarpet'
require 'net/http'

# see https://www.gitbook.com/book/renuo/rails-application-setup-guide/edit#/edit/master/templates/auto_copy_files.md

class ApplicationSetupAutoConfig
  class ListExtractor < Redcarpet::Render::Base
    attr_reader :files

    def list(_contents, _list_type)
      @next_is_hint = true
      ''
    end

    def list_item(text, _list_type)
      @files ||= []
      if @next_is_hint
        @files.last.unshift text
        @next_is_hint = false
      else
        @files << [text.strip]
      end
      ''
    end
  end

  def run
    renderer = ListExtractor.new
    markdown = Redcarpet::Markdown.new(renderer)
    url = 'https://raw.githubusercontent.com/renuo/rails-application-setup-guide/master/templates/auto_copy_files.md'
    data = Net::HTTP.get(URI(url))
    markdown.render(data)
    files = renderer.files
    files.each { |file, hint| handle_file(file, hint) }
  end

  def handle_file(file, hint)
    base_url = 'https://raw.githubusercontent.com/renuo/rails-application-setup-guide/master/templates/'
    if agree("Overwrite #{file}#{" (#{hint})" if hint}?")
      `curl #{base_url}#{file} > #{file}`
    else
      puts "Skipping file #{base_url}#{file}"
    end
  end
end
