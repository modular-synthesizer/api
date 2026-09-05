# frozen_string_literal: true

module Modusynth
  module Models
    module Concerns
      autoload :Deletable, './models/concerns/deletable'
      autoload :Enumerable, './models/concerns/enumerable'
      autoload :Ownable, './models/concerns/ownable'
      autoload :Parameter, './models/concerns/parameter'
    end
  end
end
