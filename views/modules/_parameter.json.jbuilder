json.id parameter.id.to_s
json.(parameter, :value)
json.(parameter.template, :field, :name, :targets, :minimum, :maximum, :step, :precision)
json.blocked !parameter.editable_by?(account: session.account)