json.id generator.id.to_s
json.code generator.complete_code
json.(generator, :name, :parameters, :inputs, :outputs)