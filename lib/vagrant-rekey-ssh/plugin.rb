require "vagrant-rekey-ssh/version"
require "vagrant/plugin"

module VagrantPlugins
  module RekeySSH  
    class Plugin < Vagrant.plugin("2")
      name "vagrant-rekey-ssh"
      description <<-DESC
        Automatically secure vagrant boxes with a randomly generated SSH key
      DESC

      #
      # what I really want to do is wrap the virtualbox provider somehow so we
      # can modify the machine configuration. This is good enough for now..
      #
      
      require_relative 'actions/secure_box'
      require_relative 'actions/ssh_info'
      
      %w{halt provision reload ssh ssh_run ssh_config up}.each do |action|
        action_hook(:rekey_ssh, "machine_action_#{action}".to_sym) do |hook|
          
          hook.before(Vagrant::Action::Builtin::ConfigValidate, ActionSSHInfo)
          hook.before(Vagrant::Action::Builtin::GracefulHalt, ActionSSHInfo)
          hook.before(Vagrant::Action::Builtin::SSHExec, ActionSSHInfo)
          hook.before(Vagrant::Action::Builtin::SSHRun, ActionSSHInfo)
          
          hook.after(Vagrant::Action::Builtin::Provision, ActionSecureBox)
        end
      end

      config(:rekey_ssh) do
        require_relative "config"
        Config
      end
    end
  end
end
