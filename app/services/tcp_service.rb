require 'socket'
require 'timeout'

class TcpService
  def initialize(host, port, serial = 0)
    @socket = connect(host, port, 5)
    # socket_addr = Socket.pack_sockaddr_in(port, host)
    # @socket.connect socket_addr
    @serial = serial
    @receive_timeout = 5
  end

  def connect(host, port, timeout = 5)

    # Convert the passed host into structures the non-blocking calls
    # can deal with
    addr = Socket.getaddrinfo(host, nil)
    sockaddr = Socket.pack_sockaddr_in(port, host)

    Socket.new(Socket.const_get(addr[0][0]), Socket::SOCK_STREAM, 0).tap do |socket|
      socket.setsockopt(Socket::IPPROTO_TCP, Socket::TCP_NODELAY, 1)

      begin
        # Initiate the socket connection in the background. If it doesn't fail
        # immediatelyit will raise an IO::WaitWritable (Errno::EINPROGRESS)
        # indicating the connection is in progress.
        socket.connect_nonblock(sockaddr)

      rescue IO::WaitWritable
        # IO.select will block until the socket is writable or the timeout
        # is exceeded - whichever comes first.
        if IO.select(nil, [socket], nil, timeout)
          begin
            # Verify there is now a good connection
            socket.connect_nonblock(sockaddr)
          rescue Errno::EISCONN
            # Good news everybody, the socket is connected!
          rescue
            # An unexpected exception was raised - the connection is no good.
            socket.close
            raise
          end
        else
          # IO.select returns nil when the socket is not ready before timeout
          # seconds have elapsed
          socket.close
          raise "Connection timeout"
        end
      end
    end
  end


  def send_command(device_id, command)
    serial = next_serial
    packet = "55AA01"
    packet << int_to_hex(serial, 1)
    packet << int_to_hex(4 + command.size, 2)
    packet << int_to_hex(device_id, 4)

    p = [packet].pack('H*')
    p << command
    puts p.unpack("H*")[0].upcase
    @socket.write p

    data = read_feedback(1)
    if data == -1
      return data
    end

    data[12..13]
  end

  def broadcast_msg(device_id, duration, text)
    serial = next_serial
    packet = "55AA02"
    packet << int_to_hex(serial, 1)
    packet << int_to_hex(6 + text.each_byte.to_a.size, 2)
    packet << int_to_hex(device_id, 4)
    packet << int_to_hex(duration, 2)

    p = [packet].pack('H*')
    text.bytes.each do |b|
      p << b
    end
    puts p.unpack("H*")[0].upcase
    @socket.write p

    read_feedback(0)
  end

  def start_app(device_id, app_id, app_name, app_version)
    json = {
      app_id: app_id,
      name: app_name,
      version: app_version,
    }.to_json

    serial = next_serial
    packet = "55AA03"
    packet << int_to_hex(serial, 1)
    packet << int_to_hex(4 + json.each_byte.to_a.size, 2)
    packet << int_to_hex(device_id, 4)

    p = [packet].pack('H*')
    json.bytes.each do |b|
      p << b
    end
    puts p.unpack("H*")[0].upcase
    @socket.write p

    read_feedback(0)
  end

  def read_feedback(len)
    @recv_buff = ''
    Timeout::timeout(@receive_timeout) do
      loop do
        @recv_buff << @socket.recv(6 + len)
        if @recv_buff.size >= 6 + len
          break
        end
      end
    end

    data = @recv_buff.unpack('H*')[0]
  rescue Timeout::Error => e
    puts "receive timeout"
    return -1
  end

  def close
    @socket.close
  end

  def next_serial
    @serial += 1
  end


  def int_to_hex(number, length)
    number.to_s(16).rjust(length * 2, '0')
  end
end