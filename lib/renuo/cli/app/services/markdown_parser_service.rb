require 'redcarpet'

class MarkdownParserService
  class ListExtractor < Redcarpet::Render::Base
    attr_reader :files

    def list(_contents, _list_type)
      @next_is_hint = true
      ''
    end

    def list_item(text, _list_type)
      @files ||= []
      if @next_is_hint
        @files.last.unshift text.strip
        @next_is_hint = false
      else
        @files << [text.strip]
      end
      ''
    end
  end

  def parse_markdown(markdown_text)
    renderer = ListExtractor.new
    markdown = Redcarpet::Markdown.new(renderer)
    markdown.render(markdown_text)
    renderer.files
  end
end
