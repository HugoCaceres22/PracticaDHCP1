Vagrant.configure("2") do |config|
  # Servidor
  config.vm.define "server" do |server|
    server.vm.box = "generic/debian12"
    server.vm.hostname = "server"

    server.vm.network "private_network", ip: "192.168.56.10" 
    server.vm.network "private_network", virtualbox__intnet: "redinterna1", ip: "192.168.57.10"
    
    server.vm.provision "shell", path: "provision_server.sh", privileged:true
  end

  # c1
  config.vm.define "c1" do |c1|
    c1.vm.box = "generic/debian12"
    c1.vm.hostname = "c1"
    c1.vm.network "private_network", virtualbox__intnet: "redinterna1", type: "dhcp"
  end

  # c2
  config.vm.define "c2" do |c2|
    c2.vm.box = "generic/debian12"
    c2.vm.hostname = "c2"
    c2.vm.network "private_network", virtualbox__intnet: "redinterna1",type: "dhcp"
  end
end


