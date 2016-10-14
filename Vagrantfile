# Example 6
#
# Pulling out all the stops with cluster of seven Vagrant boxes.
#
domain   = 'linkhub.local.dev'

nodes = [
  { :hostname => 'proxy',   :ip => '192.168.10.42', :box => 'bento/debian-8.5' },
  { :hostname => 'db1',     :ip => '192.168.10.43', :box => 'bento/debian-8.5' },
  { :hostname => 'db2',     :ip => '192.168.10.44', :box => 'bento/debian-8.5' },
  { :hostname => 'web1',    :ip => '192.168.10.45', :box => 'bento/debian-8.5' },
  { :hostname => 'web2',    :ip => '192.168.10.46', :box => 'bento/debian-8.5' },
  { :hostname => 'static1', :ip => '192.168.10.47', :box => 'bento/debian-8.5' },
  { :hostname => 'cache',   :ip => '192.168.10.48', :box => 'bento/debian-8.5' },
]

Vagrant.configure("2") do |config|
  nodes.each do |node|
    config.vm.define node[:hostname] do |nodeconfig|
      nodeconfig.vm.box = "bento/debian-8.5"
      nodeconfig.vm.hostname = node[:hostname] + ".box"
      nodeconfig.vm.network :private_network, ip: node[:ip]

      memory = node[:ram] ? node[:ram] : 512;
      nodeconfig.vm.provider :virtualbox do |vb|
        vb.customize [
          "modifyvm", :id,
          "--cpuexecutioncap", "50",
          "--memory", memory.to_s,
        ]
      end
    end
  end

  config.vm.define "web1" do |web|
    web.vm.synced_folder "../src/webroot/", "/srv/www"
  end
  
  config.vm.provision :shell, path: "bootstrap.sh"
  
  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file = "site.pp"
    puppet.module_path = "puppet/modules"
  end
end
