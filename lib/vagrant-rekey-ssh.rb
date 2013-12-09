require "pathname"
require 'vagrant-rekey-ssh/plugin'

module VagrantPlugins
  module RekeySSH
    lib_path = Pathname.new(File.expand_path("../vagrant-rekey-ssh", __FILE__))
    autoload :Errors, lib_path.join("errors")

    # This initializes the i18n load path so that the plugin-specific
    # translations work.
    def self.init_i18n
      I18n.load_path << File.expand_path("locales/en.yml", source_root)
      I18n.reload!
    end

    # This returns the path to the source of this plugin.
    #
    # @return [Pathname]
    def self.source_root
      @source_root ||= Pathname.new(File.expand_path("../../", __FILE__))
    end
  end
end

if defined?(Vagrant)
  VagrantPlugins::RekeySSH.init_i18n()
end
