# frozen_string_literal: true

module Modusynth
  module Models
    module Blueprints
      autoload :Control, './models/blueprints/control'
      autoload :Descriptor, './models/blueprints/descriptor'
      autoload :Generator, './models/blueprints/generator'
      autoload :InnerLink, './models/blueprints/inner_link'
      autoload :InnerLinkEnd, './models/blueprints/inner_link_end'
      autoload :InnerNode, './models/blueprints/inner_node'
      autoload :ParameterTemplate, './models/blueprints/parameter_template'
      autoload :PortTemplate, './models/blueprints/port_template'
      autoload :Blueprint, './models/blueprints/blueprint'
    end
  end
end
