Vagrant.configure("2") do |config|
  # Servidor DHCP
  config.vm.define "server" do |server|
    server.vm.box = "generic/debian12"
    server.vm.hostname = "server"

    # Interfaces
    server.vm.network "private_network", ip: "192.168.56.10" # host-only con Internet
    server.vm.network "private_network", virtualbox__intnet: "redinterna1", ip: "192.168.57.10"
    
    # Provisión
    server.vm.provision "shell", path: "provision_server.sh"
  end

  # Cliente c1
  config.vm.define "c1" do |c1|
    c1.vm.box = "generic/debian12"
    c1.vm.hostname = "c1"
    c1.vm.network "private_network", virtualbox__intnet: "redinterna1"
    c1.vm.provision "shell", path: "provision_c.sh"
  end

  # Cliente c2
  config.vm.define "c2" do |c2|
    c2.vm.box = "generic/debian12"
    c2.vm.hostname = "c2"
    c2.vm.network "private_network", virtualbox__intnet: "redinterna1"
    c2.vm.provision "shell", path: "provision_c.sh"
  end
end


