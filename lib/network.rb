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

  # Note: this is very shaky!
  def self.check_address(address)
    IO.popen("sudo ping6 -v -i1 -c1 #{address} 2>&1") { |io|
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
end