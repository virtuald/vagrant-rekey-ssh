module VagrantPlugins
  module RekeySSH
    class Config < Vagrant.plugin(2, :config)
      attr_accessor :enable

      def initialize
        @enable = UNSET_VALUE
      end
      def finalize!
        @enable = true if @enable == UNSET_VALUE
      end

      def validate(machine)
        case @enable
        when TrueClass, FalseClass
          {}
        else
          {"enable" => [I18n.t("vagrant_rekey_ssh.config.enable")] }
        end
      end

    end
  end
end