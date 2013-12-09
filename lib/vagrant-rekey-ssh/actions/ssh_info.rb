
require 'vagrant/util/subprocess'
require "vagrant-rekey-ssh/helpers"

module VagrantPlugins
  module RekeySSH
    class ActionSSHInfo
      
      def initialize(app, env)
        @app = app
        @env = env
        @machine = env[:machine]
      end
      
      def call(env)
        
        if @machine.config.rekey_ssh.enable
        
          # ensure we have a key
          generate_ssh_key
          
          # if the user's config hasn't specified a key, then set our key
          # in here. We also specify the insecure key too so that it works
          # in case we haven't replaced the key yet.
          # -> TODO: only specify the insecure key when we haven't set the
          #    less insecure key on the box.
          
          if @machine.config.ssh.private_key_path.nil?
            
            if ::File.exists?(rekey_sentinel_file)
              @machine.config.ssh.private_key_path = ssh_key_path
            end
            
            # Vagrant < 1.4 only supports a single ssh key, do this differently
            #if Vagrant::VERSION <= "1.4.0"
            #else
            #  @machine.config.ssh.private_key_path = [ssh_key_path, @machine.env.default_private_key_path]
            #end
          end
          
        end
        
        @app.call(env)
        
      end
      
      protected
      
      include VagrantPlugins::RekeySSH::Helpers
      
    end
  end
end
