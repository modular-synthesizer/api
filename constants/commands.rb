# frozen_string_literal: true

module Commands
  ADD_MEMBERSHIP = 'add.membership'
  ADD_MODULE = 'add.module'
  REMOVE_MEMBERSHIP = 'remove.membership'
  REMOVE_MODULE = 'remove.module'
  UPDATE_MODULE = 'update.module'
  UPDATE_PARAM =  'update.parameter'

  class << self
    def add_module(mod)
      "#{mod.synthesizer.id}.#{ADD_MODULE}"
    end

    def remove_module(mod)
      "#{mod.synthesizer.id}.#{REMOVE_MODULE}"
    end

    def update_module(mod)
      "#{mod.synthesizer.id}.#{UPDATE_MODULE}"
    end

    def update_param(parameter)
      "#{parameter.id}.#{UPDATE_PARAM}"
    end
  end
end
