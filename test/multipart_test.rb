require_relative "test_helper"

class MultipartTest < Minitest::Test
  def test_encodes_fields_and_the_file
    multipart = Fiken::Multipart.new(
      {filename: "kvittering-ø.pdf", name: "Kvittering", description: nil},
      file: StringIO.new("%PDF-1.4".b),
      filename: "kvittering-ø.pdf"
    )
    boundary = multipart.content_type[/\Amultipart\/form-data; boundary=(.+)\z/, 1]

    expected = "--#{boundary}\r\nContent-Disposition: form-data; name=\"filename\"\r\n\r\nkvittering-ø.pdf\r\n" \
      "--#{boundary}\r\nContent-Disposition: form-data; name=\"name\"\r\n\r\nKvittering\r\n" \
      "--#{boundary}\r\nContent-Disposition: form-data; name=\"file\"; filename=\"kvittering-ø.pdf\"\r\n" \
      "Content-Type: application/pdf\r\n\r\n%PDF-1.4\r\n--#{boundary}--\r\n"
    assert_equal expected.b, multipart.body
  end

  def test_names_the_content_type_of_each_accepted_file_type
    {
      "receipt.PDF" => "application/pdf",
      "receipt.jpeg" => "image/jpeg",
      "receipt.jpg" => "image/jpeg",
      "receipt.png" => "image/png",
      "receipt.gif" => "image/gif",
      "receipt" => "application/octet-stream"
    }.each do |filename, content_type|
      body = Fiken::Multipart.new({}, file: StringIO.new(""), filename: filename).body

      assert_includes body, "Content-Type: #{content_type}\r\n"
    end
  end
end
