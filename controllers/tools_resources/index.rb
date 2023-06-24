# frozen_string_literal: true

module Modusynth
  module Controllers
    module ToolsResources
      autoload :Base, './controllers/tools_resources/base'
      autoload :Controls, './controllers/tools_resources/controls'
      autoload :InnerNodes, './controllers/tools_resources/inner_nodes'
      autoload :Parameters, './controllers/tools_resources/parameters'
      autoload :Ports, './controllers/tools_resources/ports'
    end
  end
end
