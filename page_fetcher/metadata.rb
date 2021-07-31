require 'json'
require 'nokogiri'
require 'time'

class PageFetcher
  class Metadata
    # Record fetch time in JSON file
    LAST_FETCH_PATH = File.expand_path('last_fetch.json', File.dirname(__FILE__))

    def initialize(host:, body:)
      @host = host
      @body = body
      @last_fetch = last_fetch
      @num_links = count_tag('a')
      @num_images = count_tag('img')
    end

    def print
      puts "site: #{@host}"
      puts "num_links: #{@num_links}"
      puts "images: #{@num_images}"
      puts "last_fetch: #{@last_fetch.nil? ? 'NA' : @last_fetch}"
    end

    def record_fetch_time
      last_fetch = load_fetch_time
      last_fetch[@host] = Time.now.strftime("%a %b %d %Y %R %Z")
      save_fetch_time(last_fetch)
    end

    private

    def count_tag(tag)
      Nokogiri::HTML(@body).css(tag).size
    end

    def load_fetch_time
      if File.exist?(LAST_FETCH_PATH)
        File.open(LAST_FETCH_PATH) do |f|
          data = JSON.parse(f.read)
          return data
        end
      end

      Hash.new
    end

    def save_fetch_time(data)
      File.open(LAST_FETCH_PATH, "w+") do |f|
        f << data.to_json
      end
    end

    def last_fetch
      fetch_time = load_fetch_time
      fetch_time[@host]
    end
  end
end
