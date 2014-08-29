
require 'sshkey'

module VagrantPlugins
  module RekeySSH
    module Helpers
      
      def generate_ssh_key
        unless ::File.exists?(ssh_key_path)

          @machine.ui.info(I18n.t("vagrant_rekey_ssh.info.generating_key"))
                    
          key = SSHKey.generate(:comment => "vagrant less insecure private key")
          begin
            File.write(ssh_key_path, key.private_key)
            File.write(ssh_pubkey_path, key.ssh_public_key)
          rescue => exc
            raise Errors::ErrorCreatingSshKey, error_message: exc.message
          end
          
          @machine.ui.info(I18n.t("vagrant_rekey_ssh.info.key_generated", :path => ssh_key_path))
          
        end
      end
      
      def rekey_sentinel_file
        ::File.join(@machine.data_dir, "rekey_sentinel")
      end
      
      def ssh_public_key
        IO.read(ssh_pubkey_path).scan( /^(\S+\s+\S+).*$/ ).last.first
      end
      
      def ssh_key_path
        ::File.join(@env[:home_path], "less_insecure_private_key")
      end
      
      def ssh_pubkey_path
         ::File.join(@env[:home_path], "less_insecure_private_key.pub")
      end
    end
    
  end
end