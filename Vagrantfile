# -*- mode: ruby -*-
# vi: set ft=ruby :

domain = 'example.com'

puppet_nodes = [  
      {:hostname => 'puppet', :ip => '192.168.2.50', :box => 'lucid32', :fwdhost => 8140, :fwdguest => 8140, :ram => 512},
      {:hostname => 'client1', :ip => '192.168.2.51', :box => 'lucid32'},
      {:hostname => 'client2', :ip => '192.168.2.52', :box => 'lucid32'},
      #{:hostname => 'client3', :ip => '192.168.2.53', :box => 'lucid32'},
    ]
hosts = []

Vagrant::Config.run do |config|
  puppet_nodes.each do |node|
    config.vm.define node[:hostname] do |node_config|
        if node[:fwdhost]
          node_config.vm.forward_port(node[:fwdguest], node[:fwdhost])
          end
        if node[:box]
          node_config.vm.box = node[:box]
          node_config.vm.box_url = "http://files.vagrantup.com/" + node_config.vm.box + ".box"
        end

      memory = node[:ram] ? node[:ram] : 256;

      node_config.vm.customize ["modifyvm", :id,
                                  "--name", node[:hostname],
                                  "--memory", memory.to_s]

      node_config.vm.host_name = node[:hostname]

      node_config.vm.network :hostonly, node[:ip]

      node_config.vm.host_name = node[:hostname] + '.' + domain
      #node_config.hosts.name  = node[:hostname]
      config.hosts.aliases = [node[:hostname]]

      node_config.vm.provision :puppet do |puppet|
        puppet.manifests_path = 'provision/manifests'
        puppet.module_path = 'provision/modules'  
        #puppet.options = ["--verbose","--debug"]
      end
    end
  end
end
