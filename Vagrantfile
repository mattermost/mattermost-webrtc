# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/xenial64"

  config.vm.network 'private_network', ip: '192.168.90.10'
  config.vm.hostname = 'webrtc.mattermost.dev'

  config.vm.synced_folder "./vagrant", "/vagrant_data"

  config.vm.provider 'virtualbox' do |v|
      v.memory = 2048
      v.cpus = 2
      v.name = 'Mattermost Webrtc'
  end
end
