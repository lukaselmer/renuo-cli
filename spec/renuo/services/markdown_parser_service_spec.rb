require 'spec_helper'
require 'renuo/cli/app/services/markdown_parser_service'

describe MarkdownParserService do
  it 'parses some basic markdown' do
    markdown = "* some\n* few\n* items"
    expect(MarkdownParserService.new.parse_markdown(markdown)).to eq([%w(some), %w(few), %w(items)])
  end

  it 'parses markdown with hints' do
    markdown = "* some\n* few\n  * hint\n* items"
    expect(MarkdownParserService.new.parse_markdown(markdown)).to eq([%w(some), %w(few hint), %w(items)])
  end

  it 'parses markdown with multiple hints at the end' do
    markdown = "* some\n* few\n  * hint\n* items\n  * hint2"
    expect(MarkdownParserService.new.parse_markdown(markdown)).to eq([%w(some), %w(few hint), %w(items hint2)])
  end

  it 'parses markdown with multiple hints at the beginning' do
    markdown = "* some\n  * hint2\n* few\n  * hint\n* items"
    expect(MarkdownParserService.new.parse_markdown(markdown)).to eq([%w(some hint2), %w(few hint), %w(items)])
  end
end
