# frozen_string_literal: true

module Commands
  ADD_MEMBERSHIP = 'add.membership'
  ADD_MODULE = 'add.module'
  REMOVE_MEMBERSHIP = 'remove.membership'

  class << self
    def add_module(mod)
      "#{mod.synthesizer.id}.#{ADD_MODULE}"
    end
  end
end
