# frozen_string_literal: true

module Modusynth
  module Controllers
    autoload :Accounts, './controllers/accounts'
    autoload :Base, './controllers/base'
    autoload :Blueprints, './controllers/blueprints/index'
    autoload :Categories, './controllers/categories'
    autoload :Generators, './controllers/generators'
    autoload :Groups, './controllers/groups'
    autoload :Links, './controllers/links'
    autoload :Memberships, './controllers/memberships'
    autoload :Modules, './controllers/modules'
    autoload :Parameters, './controllers/parameters'
    autoload :Ports, './controllers/ports'
    autoload :Rights, './controllers/rights'
    autoload :Sessions, './controllers/sessions'
    autoload :Synthesizers, './controllers/synthesizers'
  end
end
