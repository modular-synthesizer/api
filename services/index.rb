module Modusynth
  module Services
    autoload :Accounts, './services/accounts'
    autoload :Authentication, './services/authentication'
    autoload :Base, './services/base'
    autoload :Categories, './services/categories'
    autoload :Concerns, './services/concerns/index'
    autoload :Generators, './services/generators'
    autoload :Links, './services/links'
    autoload :Modules, './services/modules'
    autoload :OAuth, './services/oauth/index'
    autoload :Descriptors, './services/descriptors'
    autoload :Permissions, './services/permissions/index'
    autoload :Ports, './services/ports'
    autoload :Sessions, './services/sessions'
    autoload :Synthesizers, './services/synthesizers'
    autoload :Tools, './services/tools/index'
  end
end