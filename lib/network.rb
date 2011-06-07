module Network
  
  ### ADDRESSES ###

  def self.addresses(interface, prefix)
    output = `ifconfig #{interface} | grep -v temporary | grep inet6 | grep #{prefix}`
    output.split("\n").map { |line| line.match("inet6 ([0-9a-f:]+) ")[1] }
  end

  def self.remove_address(interface, address)
    `sudo ifconfig #{interface} inet6 #{address} delete`
  end

  def self.add_address(interface, address)
    `sudo ifconfig #{interface} inet6 alias #{address}`
  end

  def self.check_address(address, source_address)
    STDERR.puts("sudo ping6 -S#{source_address} -v -i1 -c1 #{address} 2>&1")
    IO.popen("sudo ping6 -S#{source_address} -v -i1 -c1 #{address} 2>&1") { |io|
      while line = io.gets
        if line =~ /ret=-1/ || line =~ /Destination Administratively Unreachable/
          `kill -9 #{io.pid}`
          return false
        end
        if line =~ /^16 bytes/
          `kill -9 #{io.pid}`
          return true
        end
      end
    }
    return $? == 0
  end
  
  ### FIREWALL ###
  def self.firewall_flush
    `sudo ip6fw -f flush`
  end

  def self.v6_prefix(interface)
    address = `ifconfig #{interface} | grep prefixlen | grep -v ' fe' | head -1`
    if address =~ / (([a-z0-f]{1,4}:){4,4})/
      return $1[0..-2]
    end
    return nil
  end
  
  def self.monitor_icmp(interface, prefix)
    command = "sudo tcpdump -l -i #{interface} icmp6 2>&1"
    # STDERR.puts("Runnig command: #{command}")
    IO.popen(command) do |io|
      while line = io.gets
          next unless line =~ /#{prefix}/
          next if line =~ /neighbor/
        yield line.strip
      end
    end
  end
  
end