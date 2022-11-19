def create_empty_tool session, payload = {}
  post '/', {auth_token: session.token}.merge(payload).to_json
end

def create_simple_tool session, additional_payload = {}
  create_empty_tool(session, {name: 'VCA', slots: 3}.merge(additional_payload))
end

def create_tool_with_inner_node session
  create_simple_tool(session, {
    innerNodes: [
      {name: 'gain', generator: 'GainNode'}
    ]
  })
end

def create_tool_with_inner_link session
  create_simple_tool(session, {
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

def create_tool_with_parameter session, descriptor
  create_simple_tool(session, {
    parameters: [
      {targets: ['gain'], descriptor: descriptor.id.to_s, x: 20, y: 30}
    ]
  })
end

def create_tool_with_input session
  create_simple_tool(session, {
    inputs: [
      {name: 'INPUT', target: 'gain', index: 0}
    ]
  })
end

def create_tool_with_output session
  create_simple_tool(session, {
    outputs: [
      {name: 'OUTPUT', target: 'gain', index: 0}
    ]
  })
end