# -*- mode: ruby -*-7g
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "generic/debian12" # platilla de la máquinaaa

  config.vm.define "server" do |server| # el segundo server es una variable que se pone al principio del resto de cosas
      server.vm.hostname = "server"
      server.vm.network "private_network" , ip: "192.168.56.10"
     # server.vm.provision "shell" , path:"provision-server.sh"
end  #web

config.vm.define "c1" do |c1|
    c1.vm.hostname = "c1"
    #c1.vm.network "private_network" , ip: "192.168.56.20"
    #c1.vm.provision "shell" , path:"provision-c1.sh"

config.vm.define "c2" do |c2|
    c2.vm.hostname = "c2"
    #c2.vm.network "private_network" , ip: "192.168.56.20"
    #c2.vm.provision "shell" , path:"provision-c2.sh"


end # c2
end # Vagrant.configurea
