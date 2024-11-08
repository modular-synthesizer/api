# frozen_string_literal: true

module Modusynth
  module Models
    module Concerns
      autoload :Ownable, './models/concerns/ownable'
      autoload :Deletable, './models/concerns/deletable'
      autoload :Enumerable, './models/concerns/enumerable'
    end
  end
end
