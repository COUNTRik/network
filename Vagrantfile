# -*- mode: ruby -*-
# vim: set ft=ruby :
# -*- mode: ruby -*-
# vim: set ft=ruby :

MACHINES = {

:inetRouter => {
      :box_name => "centos/6",
      #:public => {:ip => '10.10.10.1', :adapter => 1},
      :net => [
                 {ip: '192.168.255.1', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "router-net"},
              ]
},

:centralRouter => {
      :box_name => "centos/7",
      :net => [
                 {ip: '192.168.255.2', adapter: 2, netmask: "255.255.255.252", virtualbox__intnet: "router-net"},
                 {ip: '192.168.3.1', adapter: 3, netmask: "255.255.255.248", virtualbox__intnet: "local-net"},
                 {ip: '192.168.0.1', adapter: 4, netmask: "255.255.255.128", virtualbox__intnet: "dir-net"},
                 {ip: '192.168.0.129', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "hw-net"},
                 {ip: '192.168.0.193', adapter: 6, netmask: "255.255.255.192", virtualbox__intnet: "wifi-net"},
              ]
},

:office1Router => {
      :box_name => "centos/7",
      :net => [
                 {ip: '192.168.3.2', adapter: 2, netmask: "255.255.255.248", virtualbox__intnet: "local-net"},
                 {ip: '192.168.2.1', adapter: 3, netmask: "255.255.255.192", virtualbox__intnet: "dev-net"},
                 {ip: '192.168.2.65', adapter: 4, netmask: "255.255.255.192", virtualbox__intnet: "test-net"},
                 {ip: '192.168.2.129', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "mgs-net"},
                 {ip: '192.168.2.192', adapter: 6, netmask: "255.255.255.192", virtualbox__intnet: "hw-net"},
              ]
},

:office2Router => {
      :box_name => "centos/7",
      :net => [
                 {ip: '192.168.3.3', adapter: 2, netmask: "255.255.255.248", virtualbox__intnet: "local-net"},
                 {ip: '192.168.1.1', adapter: 3, netmask: "255.255.255.128", virtualbox__intnet: "dev-net"},
                 {ip: '192.168.1.129', adapter: 4, netmask: "255.255.255.192", virtualbox__intnet: "test-net"},
                 {ip: '192.168.1.193', adapter: 5, netmask: "255.255.255.192", virtualbox__intnet: "hw-net"},
              ]
},

:centralServer => {
      :box_name => "centos/7",
      :net => [
                 {ip: '192.168.0.2', adapter: 2, netmask: "255.255.255.240", virtualbox__intnet: "dir-net"},
              ]
},

:office1Server => {
      :box_name => "centos/7",
      :net => [
                 {ip: '192.168.2.4', adapter: 2, netmask: "255.255.255.192", virtualbox__intnet: "dev-net"},
              ]
},

:office2Server => {
      :box_name => "centos/7",
      :net => [
                 {ip: '192.168.1.4', adapter: 2, netmask: "255.255.255.128", virtualbox__intnet: "dev-net"},
              ]
},
  
}

Vagrant.configure("2") do |config|

  MACHINES.each do |boxname, boxconfig|

    config.vm.define boxname do |box|

        box.vm.box = boxconfig[:box_name]
        box.vm.host_name = boxname.to_s

        boxconfig[:net].each do |ipconf|
          box.vm.network "private_network", ipconf
        end
        
        if boxconfig.key?(:public)
          box.vm.network "public_network", boxconfig[:public]
        end
        
        case boxname.to_s
        when "inetRouter"
          box.vm.provision "shell", path: "scripts/inetRouter.sh"
          
        when "centralRouter"
          box.vm.provision "shell", path: "scripts/centralRouter.sh"
          
        when "office1Router"
          box.vm.provision "shell", path: "scripts/office1Router.sh"
        
        when "office2Router"
          box.vm.provision "shell", path: "scripts/office2Router.sh"

        when "centralServer"
          box.vm.provision "shell", path: "scripts/centralServer.sh"

        when "office1Server"
          box.vm.provision "shell", path: "scripts/office1Server.sh"

        when "office2Server"
          box.vm.provision "shell", path: "scripts/office2Server.sh"

        end

      end

  end
  
  
end