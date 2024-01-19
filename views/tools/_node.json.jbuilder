json.id node.id.to_s
json.(node, :name, :generator, :x, :y, :polyphonic)
json.(node.generator_object, :inputs, :outputs) if node.generator_object