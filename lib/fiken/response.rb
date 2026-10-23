module Fiken
  class Response
    attr_reader :status, :data

    def initialize(status:, body:, headers: {})
      @status = status
      @headers = headers.transform_keys(&:downcase)
      @data = parse(body)
    end

    def success?
      status.between?(200, 299)
    end

    def location
      header("Location")
    end

    def created_id
      location&.split("/")&.last
    end

    def page
      integer_header("Fiken-Api-Page")
    end

    def page_size
      integer_header("Fiken-Api-Page-Size")
    end

    def page_count
      integer_header("Fiken-Api-Page-Count")
    end

    def result_count
      integer_header("Fiken-Api-Result-Count")
    end

    def last_page?
      page.nil? || page_count.nil? || page + 1 >= page_count
    end

    def error_message
      case data
      when Hash then data["error_description"] || data["message"] || data["error"]
      when String then data unless data.empty?
      end
    end

    private

    def parse(body)
      return if body.nil? || body.strip.empty?

      JSON.parse(body)
    rescue JSON::ParserError
      body
    end

    def header(name)
      @headers[name.downcase]
    end

    def integer_header(name)
      header(name)&.to_i
    end
  end
end
