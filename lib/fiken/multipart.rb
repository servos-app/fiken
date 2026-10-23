module Fiken
  class Multipart
    # The file types Fiken accepts as attachments.
    CONTENT_TYPES = {
      ".gif" => "image/gif",
      ".jpeg" => "image/jpeg",
      ".jpg" => "image/jpeg",
      ".pdf" => "application/pdf",
      ".png" => "image/png"
    }.freeze

    def initialize(fields, file:, filename:)
      @fields = fields.compact
      @file = file
      @filename = filename
      @boundary = "fiken-#{SecureRandom.hex(16)}"
    end

    def content_type
      "multipart/form-data; boundary=#{@boundary}"
    end

    def body
      @body ||= begin
        parts = @fields.map { |name, value| part(%(name="#{name}"), value.to_s) }
        parts << part(%(name="file"; filename="#{@filename}"), @file.read, type: file_content_type)
        (parts.join + "--#{@boundary}--\r\n").b
      end
    end

    private

    def part(disposition, content, type: nil)
      headers = ["Content-Disposition: form-data; #{disposition}", ("Content-Type: #{type}" if type)].compact
      "--#{@boundary}\r\n#{headers.join("\r\n")}\r\n\r\n".b + content.b + "\r\n"
    end

    def file_content_type
      CONTENT_TYPES.fetch(File.extname(@filename.to_s).downcase, "application/octet-stream")
    end
  end
end
