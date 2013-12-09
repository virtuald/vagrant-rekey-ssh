require "vagrant"

module VagrantPlugins
  module RekeySSH
    module Errors
      class VagrantRekeySSHError < Vagrant::Errors::VagrantError
        error_namespace("vagrant_rekey_ssh.errors")
      end
      
      class ErrorSshKeygenNotFound < VagrantRekeySSHError
        error_key(:ssh_keygen_not_found)
      end
      
      class ErrorCreatingSshKey < VagrantRekeySSHError
        error_key(:creating_ssh_key)
      end
      
      class ErrorInvalidGeneratedSshKey < VagrantRekeySSHError
        error_key(:invalid_generated_ssh_key)
      end
      
    end
  end
end