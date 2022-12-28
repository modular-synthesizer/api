module Modusynth
  module Services
    autoload :Accounts, './services/accounts'
    autoload :Authentication, './services/authentication'
    autoload :Categories, './services/categories'
    autoload :Concerns, './services/concerns/index'
    autoload :Generators, './services/generators'
    autoload :Links, './services/links'
    autoload :Modules, './services/modules'
    autoload :Ownership, './services/ownership'
    autoload :Parameters, './services/parameters'
    autoload :Permissions, './services/permissions/index'
    autoload :Sessions, './services/sessions'
    autoload :Synthesizers, './services/synthesizers'
    autoload :Tools, './services/tools'
  end
end