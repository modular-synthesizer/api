def create_empty_tool payload = {}
  post '/', payload.to_json
end

def create_simple_tool additional_payload = {}
  create_empty_tool({name: 'VCA', slots: 3}.merge(additional_payload))
end

def create_tool_with_inner_node
  create_simple_tool({
    innerNodes: [
      {name: 'gain', generator: 'GainNode'}
    ]
  })
end

def create_tool_with_inner_link
  create_simple_tool({
    innerNodes: [
      { name: 'gain', generator: 'GainNode' },
      { name: 'oscillator', generator: 'OscillatorNode' }
    ],
    innerLinks: [
      {
        from: {node: 'oscillator', index: 0},
        to: {node: 'gain', index: 1}
      }
    ]
  })
end

def create_tool_with_parameter descriptor
  create_simple_tool({
    parameters: [
      {targets: ['gain'], descriptor: descriptor.id.to_s}
    ]
  })
end

def create_tool_with_input
  create_simple_tool({
    inputs: [
      {name: 'INPUT', target: 'gain', index: 0}
    ]
  })
end

def create_tool_with_output
  create_simple_tool({
    outputs: [
      {name: 'OUTPUT', target: 'gain', index: 0}
    ]
  })
end