require_relative "test_helper"
require "socket"

class ConnectionTest < Minitest::Test
  def test_wraps_the_status_body_and_headers_fiken_sent
    answer = lambda do |socket|
      socket.gets("\r\n\r\n")
      socket.write "HTTP/1.1 201 Created\r\nLocation: https://api.fiken.no/api/v2/companies/demo/sales/7\r\n" \
        "Fiken-Api-Page: 1\r\nFiken-Api-Page-Count: 2\r\nContent-Length: 2\r\nConnection: close\r\n\r\n{}"
      socket.close
    end

    with_server(answer) do |port|
      response = perform(port, scheme: "http")

      assert_equal 201, response.status
      assert_equal({}, response.data)
      assert_equal "7", response.created_id
      assert response.last_page?
    end
  end

  def test_a_server_that_never_answers_raises_timeout_error
    with_server(->(socket) { socket.read }) do |port|
      assert_raises(Fiken::Errors::TimeoutError) { perform(port) }
    end
  end

  def test_refused_connections_raise_connection_error
    server = TCPServer.new("127.0.0.1", 0)
    port = server.addr[1]
    server.close

    assert_raises(Fiken::Errors::ConnectionError) { perform(port) }
  end

  def test_reset_connections_raise_connection_error
    with_server(->(socket) { socket.close }) do |port|
      assert_raises(Fiken::Errors::ConnectionError) { perform(port) }
    end
  end

  private

  def perform(port, scheme: "https")
    request = Net::HTTP::Get.new(URI("#{scheme}://127.0.0.1:#{port}/api/v2/user"))
    Fiken::Connection.perform(request, timeout: 0.2, open_timeout: 0.2)
  end

  def with_server(handler)
    server = TCPServer.new("127.0.0.1", 0)
    thread = Thread.new do
      socket = server.accept
      handler.call(socket)
    rescue IOError
      nil
    end

    yield server.addr[1]
  ensure
    server.close
    thread.kill
  end
end
