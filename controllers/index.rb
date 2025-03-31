# frozen_string_literal: true

module Modusynth
  module Controllers
    autoload :Accounts, './controllers/accounts'
    autoload :Applications, './controllers/applications'
    autoload :Base, './controllers/base'
    autoload :Categories, './controllers/categories'
    autoload :Experiments, './controllers/experiments'
    autoload :Generators, './controllers/generators'
    autoload :Groups, './controllers/groups'
    autoload :Iut, './controllers/iut'
    autoload :Links, './controllers/links'
    autoload :Memberships, './controllers/memberships'
    autoload :Modules, './controllers/modules'
    autoload :Parameters, './controllers/parameters'
    autoload :Ports, './controllers/ports'
    autoload :Rights, './controllers/rights'
    autoload :Sessions, './controllers/sessions'
    autoload :Synthesizers, './controllers/synthesizers'
    autoload :Tools, './controllers/tools'
    autoload :ToolsResources, './controllers/tools_resources/index'
  end
end
