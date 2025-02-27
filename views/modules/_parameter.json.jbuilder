# frozen_string_literal: true

json.id parameter.id.to_s
json.call(parameter, :value)
json.call(parameter.template, :field, :name, :targets, :minimum, :maximum, :step, :precision)
json.blocked !parameter.editable?
