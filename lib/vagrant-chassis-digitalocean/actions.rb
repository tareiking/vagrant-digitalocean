require 'vagrant-chassis-digitalocean/actions/check_state'
require 'vagrant-chassis-digitalocean/actions/create'
require 'vagrant-chassis-digitalocean/actions/destroy'
require 'vagrant-chassis-digitalocean/actions/power_off'
require 'vagrant-chassis-digitalocean/actions/power_on'
require 'vagrant-chassis-digitalocean/actions/rebuild'
require 'vagrant-chassis-digitalocean/actions/reload'
require 'vagrant-chassis-digitalocean/actions/setup_user'
require 'vagrant-chassis-digitalocean/actions/setup_sudo'
require 'vagrant-chassis-digitalocean/actions/setup_key'
require 'vagrant-chassis-digitalocean/actions/sync_folders'
require 'vagrant-chassis-digitalocean/actions/modify_provision_path'

module VagrantPlugins
  module DigitalOcean
    module Actions
      include Vagrant::Action::Builtin

      def self.destroy
        return Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use Call, CheckState do |env, b|
            case env[:machine_state]
            when :not_created
              env[:ui].info I18n.t('vagrant_digital_ocean.info.not_created')
            else
              b.use Call, DestroyConfirm do |env2, b2|
                if env2[:result]
                  b2.use Destroy
                  b2.use ProvisionerCleanup if defined?(ProvisionerCleanup)
                end
              end
            end
          end
        end
      end

      def self.ssh
        return Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use Call, CheckState do |env, b|
            case env[:machine_state]
            when :active
              b.use SSHExec
            when :off
              env[:ui].info I18n.t('vagrant_digital_ocean.info.off')
            when :not_created
              env[:ui].info I18n.t('vagrant_digital_ocean.info.not_created')
            end
          end
        end
      end

      def self.ssh_run
        return Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use Call, CheckState do |env, b|
            case env[:machine_state]
            when :active
              b.use SSHRun
            when :off
              env[:ui].info I18n.t('vagrant_digital_ocean.info.off')
            when :not_created
              env[:ui].info I18n.t('vagrant_digital_ocean.info.not_created')
            end
          end
        end
      end

      def self.provision
        return Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use Call, CheckState do |env, b|
            case env[:machine_state]
            when :active
              b.use Provision
              b.use ModifyProvisionPath
              b.use SyncFolders
            when :off
              env[:ui].info I18n.t('vagrant_digital_ocean.info.off')
            when :not_created
              env[:ui].info I18n.t('vagrant_digital_ocean.info.not_created')
            end
          end
        end
      end

      def self.up
        return Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use Call, CheckState do |env, b|
            case env[:machine_state]
            when :active
              env[:ui].info I18n.t('vagrant_digital_ocean.info.already_active')
            when :off
              b.use PowerOn
              b.use provision
            when :not_created
              b.use SetupKey
              b.use Create
              b.use SetupSudo
              b.use SetupUser
              b.use provision
            end
          end
        end
      end

      def self.halt
        return Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use Call, CheckState do |env, b|
            case env[:machine_state]
            when :active
              b.use PowerOff
            when :off
              env[:ui].info I18n.t('vagrant_digital_ocean.info.already_off')
            when :not_created
              env[:ui].info I18n.t('vagrant_digital_ocean.info.not_created')
            end
          end
        end
      end

      def self.reload
        return Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use Call, CheckState do |env, b|
            case env[:machine_state]
            when :active
              b.use Reload
              b.use provision
            when :off
              env[:ui].info I18n.t('vagrant_digital_ocean.info.off')
            when :not_created
              env[:ui].info I18n.t('vagrant_digital_ocean.info.not_created')
            end
          end
        end
      end

      def self.rebuild
        return Vagrant::Action::Builder.new.tap do |builder|
          builder.use ConfigValidate
          builder.use Call, CheckState do |env, b|
            case env[:machine_state]
            when :active, :off
              b.use Rebuild
              b.use SetupSudo
              b.use SetupUser
              b.use provision
            when :not_created
              env[:ui].info I18n.t('vagrant_digital_ocean.info.not_created')
            end
          end
        end
      end
    end
  end
end
