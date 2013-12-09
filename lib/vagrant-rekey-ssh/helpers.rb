
module VagrantPlugins
  module RekeySSH
    module Helpers
      
      def generate_ssh_key
        unless ::File.exists?(ssh_key_path)

          @machine.ui.info(I18n.t("vagrant_rekey_ssh.info.generating_key"))
                    
          result = Vagrant::Util::Subprocess.execute("ssh-keygen", "-f", ssh_key_path, "-N", "")
          
          if result.exit_code != 0
            raise Errors::ErrorCreatingSshKey, exit_code: result.exit_code
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