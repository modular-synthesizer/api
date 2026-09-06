# frozen_string_literal: true

json.id port.id.to_s
json.call(port, :name, :target, :kind, :index)
