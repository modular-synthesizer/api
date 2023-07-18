module Modusynth
  module Services
    class Initialization
      include Singleton

      attr_reader :client

      def initialize
        @client = K8s::Client.config(K8s::Config.from_kubeconfig_env)
      end

      # Creates some needed elements if the application has not been correctly initialized :
      # * A first administrator account with a random password that MUST be changed after init.
      # * A first application used to connect to the API
      # If it creates an application, it then updates the secret of the current environment
      # by storing its public and private keys in the corresponding secret.
      def run
        puts 'Running the initialization service'
        check_and_update_admin!
        check_and_update_application!
      end

      private

      def namespace
        ENV.fetch('KUBE_NS')
      end

      def check_and_update_admin!
        puts 'Searching for an administrator account'
        if Modusynth::Models::Account.where(admin: true).to_a.empty?
          puts 'No administrator found. Creating a first account with random password.'
          password = SecureRandom.hex(32)
          account = Modusynth::Services::Accounts.instance.create(
            username: 'administrator',
            email: 'contact@synple.app',
            password:, password_confirmation: password,
            admin: true
          )
          puts 'Storing the password in the Kubernetes cluster secrets'
          store_secret('admin_password', password)
        end
      end

      def check_and_update_application!
        puts 'Searching for an application'
        if Modusynth::Models::OAuth::Application.all.to_a.empty?
          puts 'No application found. Creating a first application'
          application = Modusynth::Services::OAuth::Applications.instance.create(
            name: 'frontend app',
            account: Modusynth::Models::Account.where(username: 'administrator').first
          )
          puts 'Storing the identifiers in the corresponding secret'
          store_secret('public-key', application.public_key)
          store_secret('private-key', application.private_key)
          puts 'Identifiers stored, this will need a frontend restart to properly work'
        end
      end

      def store_secret(name, value)
        creds = client.api('v1').resource('secrets', namespace:).get('frontend-credentials')
        creds[:data][name.to_sym] = value
        client.api('v1').resource('secrets', namespace).update(creds)
      end
    end
  end
end