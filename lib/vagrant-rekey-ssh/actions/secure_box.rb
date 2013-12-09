
require "vagrant-rekey-ssh/helpers"

module VagrantPlugins
  module RekeySSH
    class ActionSecureBox
      
      def initialize(app, env)
        @app = app
        @env = env
        @machine = env[:machine]
        @vagrant_insecure_public_key = "AAAAB3NzaC1yc2EAAAABIwAAAQEA6NF8iallvQVp22WDkTkyrtvp9eWW6A8YVr+kz4TjGYe7gHzIw+niNltGEFHzD8+v1I2YJ6oXevct1YeS0o9HZyN1Q9qgCgzUFtdOKLv6IedplqoPkcmF0aYet2PkEDo3MlTBckFXPITAMzF8dJSIFo9D8HfdOV0IAdx4O7PtixWKn5y2hMNG0zQPyUecp4pzC6kivAIhyfHilFR61RGL+GPXQ2MWZWFYbAGjyiYJnAmCP3NOTd0jMZEnDkbUvxhMmBYSdETk1rRgm+R4LOzFUGaHqHDLKLX+FIPKcF96hrucXzcWyLbIbEgE98OHlnVYCzRdK8jlqm8tehUc9c9WhQ=="
      end
      
      def call(env)
        @app.call(env)
        return unless @machine.communicate.ready?
        
        if @machine.config.rekey_ssh.enable
            
          generate_ssh_key
          
          key = ssh_public_key()
          unless key.length > 0
            raise Errors::ErrorInvalidGeneratedSshKey
          end
          
          # remove the vagrant insecure public key
          cmd = "grep #{@vagrant_insecure_public_key} ~/.ssh/authorized_keys|| exit 1"
          cmd += ";sed -i 's/^.*#{@vagrant_insecure_public_key}.*$/#{key.gsub("/","\\/")}  vagrant less insecure private key/' ~/.ssh/authorized_keys || exit 2"
          cmd += ";exit 3"
          
          result = @machine.communicate.execute(cmd, sudo: false, error_check: false)
          
          if result == 1
            @machine.ui.info(I18n.t("vagrant_rekey_ssh.info.no_key"))
          elsif result == 2
            raise Errors::ErrorReplacingInsecureKey
          elsif result == 3
            @machine.ui.info(I18n.t("vagrant_rekey_ssh.info.key_replaced"))
            
            # if the insecure key *was* there, disable the user's and root's password too
            # -> this prevents the user from logging in using 'vagrant'
            # -> we only do this if the insecure key was found, because if it
            #    wasn't then perhaps it's a custom box and we shouldn't mess with it
            @machine.communicate.execute("sudo passwd --delete $USER; sudo passwd --delete root", sudo: false)  
            
          end
          
        end
      end
      
      protected
      
      include VagrantPlugins::RekeySSH::Helpers
      
    end
  end
end
