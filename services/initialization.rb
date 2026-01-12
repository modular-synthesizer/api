module Modusynth
  module Services
    class Initialization
      include Singleton

      # Creates some needed elements if the application has not been correctly initialized :
      # * A first administrator account with a random password that MUST be changed after init.
      # * A first application used to connect to the API
      # If it creates an application, it then updates the secret of the current environment
      # by storing its public and private keys in the corresponding secret.
      def run
        puts 'Searching for an administrator account'
        if Modusynth::Models::Account.where(admin: true).to_a.empty?
          puts 'No administrator found. Creating a first account with random password.'
          password = SecureRandom.hex(32)
          account = Modusynth::Models::Account.create(
            username: 'administrator',
            email: 'contact@synple.app',
            password:,
            password_confirmation: password,
            admin: true
          )
        end
      end
    end
  end
end