require 'net/http'
require_relative 'metadata'

class PageFetcher
  class PageFetcherError < StandardError
    def initialize(uri, error)
      super("There was an error while fetching #{uri}: #{error.message}")
    end
  end

  def initialize(uri_str)
    @uri = URI.parse(uri_str)
    @body = fetch_page_body
    @host = @uri.host

    @metadata = Metadata.new(host: @host, body: @body)
    @metadata.record_fetch_time
  end

  def print_metadata
    @metadata.print
  end

  def save_contents
    File.open("#{@host}.html", mode = 'w') do |f|
      f.write(@body)
    end
  end

  private

  def fetch_page_body
    max_retry = 3
    attempt = 0

    begin
      response = Net::HTTP.get_response(@uri)
      response.value
    rescue Net::HTTPRetriableError, Net::HTTPFatalError => e
      attempt += 1
      if attempt > max_retry
        raise PageFetcherError.new(@uri, e)
      end

      retry
    rescue => e
      raise PageFetcherError.new(@uri, e)
    end

    response.body
  end
end
