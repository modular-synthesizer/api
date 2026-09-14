# frozen_string_literal: true

module Modusynth
  module Controllers
    module Blueprints
      autoload :Base, './controllers/blueprints/base'
      autoload :Blueprints, './controllers/blueprints/blueprints'
      autoload :Controls, './controllers/blueprints/controls'
      autoload :InnerLinks, './controllers/blueprints/inner_links'
      autoload :InnerNodes, './controllers/blueprints/inner_nodes'
      autoload :Parameters, './controllers/blueprints/parameters'
      autoload :Ports, './controllers/blueprints/ports'
    end
  end
end
