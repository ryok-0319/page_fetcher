#!/usr/bin/env ruby

require 'optparse'
require 'parallel'
require_relative 'page_fetcher/page_fetcher'

# default
config = {
  metadata: false
}
OptionParser.new do |opt|
  opt.on('--metadata', "If true, record metadata of the specified web page. (default: #{config[:metadata]})") do
    config[:metadata] = true
  end

  opt.parse!(ARGV)
end

urls = ARGV
fetchers = Parallel.map(urls) do |url|
  begin
    PageFetcher.new(url)
  rescue => e
    e
  end
end

is_error = false
fetchers.each do |fetcher|
  if fetcher.is_a?(Exception)
    is_error = true
    puts fetcher
    next
  end

  if config[:metadata]
    fetcher.print_metadata
  else
    fetcher.save_contents
  end
end

exit 1 if is_error
