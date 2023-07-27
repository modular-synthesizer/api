module Modusynth
  module Services
    autoload :Accounts, './services/accounts'
    autoload :AudioProcessors, './services/audio_processors'
    autoload :Authentication, './services/authentication'
    autoload :Base, './services/base'
    autoload :Categories, './services/categories'
    autoload :Concerns, './services/concerns/index'
    autoload :Generators, './services/generators'
    autoload :Initialization, './services/initialization'
    autoload :Links, './services/links'
    autoload :Memberships, './services/memberships'
    autoload :Modules, './services/modules'
    autoload :OAuth, './services/oauth/index'
    autoload :Parameters, './services/parameters'
    autoload :Permissions, './services/permissions/index'
    autoload :Ports, './services/ports'
    autoload :Sessions, './services/sessions'
    autoload :Synthesizers, './services/synthesizers'
    autoload :Tools, './services/tools/index'
    autoload :ToolsResources, './services/tools_resources/index'
  end
end