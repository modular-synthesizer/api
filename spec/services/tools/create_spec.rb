RSpec.describe 'Tool creation service' do
  let!(:service) { Modusynth::Services::Tools::Create.instance }
  let!(:dopefun) { create(:dopefun) }

  describe 'Nominal case' do
    let!(:creation) { service.create(name: 'TestTool', slots: 10, categoryId: dopefun.id.to_s) }

    it 'Has returned a persisted object' do
      expect(creation.persisted?).to be_truthy
    end
    it 'Has returned an object with the correct name' do
      expect(creation.name).to eq 'TestTool'
    end
    it 'Has returned an object with the correct number of slots' do
      expect(creation.slots).to be 10
    end
  end

  describe 'Error cases' do
    describe 'main payload errors' do
      it 'Fails if the name is not given' do
        payload = {slots: 10, categoryId: dopefun.id.to_s}
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
            .and having_attributes(key: 'name', error: 'required', prefix: '')
        )
      end
      it 'Fails if the name is nil' do
        payload = {slots: 10, categoryId: dopefun.id.to_s, name: nil}
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
            .and having_attributes(key: 'name', error: 'required', prefix: '')
        )
      end
      it 'Fails if the name is too short' do
        payload = {slots: 10, categoryId: dopefun.id.to_s, name: 'a'}
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
            .and having_attributes(key: 'name', error: 'minlength', prefix: '')
        )
      end
      it 'Fails if the slots are not given' do
        payload = {categoryId: dopefun.id.to_s, name: 'foo'}
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
            .and having_attributes(key: 'slots', error: 'required', prefix: '')
        )
      end
      it 'Fails if the slots are given as nil' do
        payload = {categoryId: dopefun.id.to_s, name: 'foo', slots: nil}
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
            .and having_attributes(key: 'slots', error: 'required', prefix: '')
        )
      end
      it 'Fails if the slots are zero' do
        payload = {categoryId: dopefun.id.to_s, name: 'foo', slots: 0}
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
            .and having_attributes(key: 'slots', error: 'value', prefix: '')
        )
      end
      it 'Fails if the slots are below zero' do
        payload = {categoryId: dopefun.id.to_s, name: 'foo', slots: -1}
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
            .and having_attributes(key: 'slots', error: 'value', prefix: '')
        )
      end
      it 'Fails if the category is not found' do
        payload = {name: 'TestTool', slots: 10, categoryId: 'invalid'}
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'categoryId', error: 'unknown', prefix: '')
        )
      end
      it 'Fails if the categoryId is not not given' do
        payload = {name: 'TestTool', slots: 10}
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'categoryId', error: 'required', prefix: '')
        )
      end
      it 'Fails if the categoryId is given as nil' do
        payload = {name: 'TestTool', slots: 10, categoryId: nil}
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'categoryId', error: 'required', prefix: '')
        )
      end
    end
    describe 'Inner nodes payload errors' do
      def create_payload inner_node
        {name: 'TestTool', slots: 10, categoryId: dopefun.id.to_s, nodes: [inner_node]}
      end
      it 'Fails if the name is not given' do
        payload = create_payload({generator: 'VolumeGenerator'})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'name', error: 'required', prefix: 'nodes[0].')
        )
      end
      it 'Fails if the name is given at nil' do
        payload = create_payload({name: nil, generator: 'VolumeGenerator'})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'name', error: 'required', prefix: 'nodes[0].')
        )
      end
      it 'Fails if the name is too short' do
        payload = create_payload({name: 'a', generator: 'VolumeGenerator'})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'name', error: 'length', prefix: 'nodes[0].')
        )
      end
      it 'Fails if the generator is not given' do
        payload = create_payload({name: 'test-node'})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'generator', error: 'required', prefix: 'nodes[0].')
        )
      end
      it 'Fails if the generator is given as nil' do
        payload = create_payload({name: 'test-node', generator: nil})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'generator', error: 'required', prefix: 'nodes[0].')
        )
      end
      it 'Fails if the generator is too short' do
        payload = create_payload({name: 'test-node', generator: 'fo'})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'generator', error: 'length', prefix: 'nodes[0].')
        )
      end
    end
    describe 'Inner link payload errors' do
      def create_payload inner_link
        {name: 'TestTool', slots: 10, categoryId: dopefun.id.to_s, links: [inner_link]}
      end
      it 'Fails if the origin is not given' do
        payload = create_payload({to: {node: 'test', index: 0}})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'from', error: 'required', prefix: 'links[0].')
        )
      end
      it 'Fails if the origin node is not given' do
        payload = create_payload({to: {node: 'test', index: 0}, from: { index: 0 }})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'node', error: 'required', prefix: 'links[0].from.')
        )
      end
      it 'Fails if the origin node is given as nil' do
        payload = create_payload({to: {node: 'test', index: 0}, from: { node: nil, index: 0 }})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'node', error: 'required', prefix: 'links[0].from.')
        )
      end
      it 'Fails if the origin node is too short' do
        payload = create_payload({to: {node: 'test', index: 0}, from: { node: 'a', index: 0 }})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'node', error: 'length', prefix: 'links[0].from.')
        )
      end
      it 'Fails if the origin index is not given' do
        payload = create_payload({to: {node: 'test', index: 0}, from: { node: 'test' }})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'index', error: 'required', prefix: 'links[0].from.')
        )
      end
      it 'Fails if the origin index is given as nil' do
        payload = create_payload({to: {node: 'test', index: 0}, from: { node: 'test', index: nil }})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'index', error: 'required', prefix: 'links[0].from.')
        )
      end
      it 'Fails if the origin index is below zero' do
        payload = create_payload({to: {node: 'test', index: 0}, from: { node: 'test', index: -1 }})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'index', error: 'value', prefix: 'links[0].from.')
        )
      end
      it 'Fails if the destination is not given' do
        payload = create_payload({from: {node: 'test', index: 0}})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'to', error: 'required', prefix: 'links[0].')
        )
      end
      it 'Fails if the destination node is not given' do
        payload = create_payload({from: {node: 'test', index: 0}, to: { index: 0 }})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'node', error: 'required', prefix: 'links[0].to.')
        )
      end
      it 'Fails if the destination node is given as nil' do
        payload = create_payload({from: {node: 'test', index: 0}, to: { node: nil, index: 0 }})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'node', error: 'required', prefix: 'links[0].to.')
        )
      end
      it 'Fails if the destination node is too short' do
        payload = create_payload({from: {node: 'test', index: 0}, to: { node: 'a', index: 0 }})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'node', error: 'length', prefix: 'links[0].to.')
        )
      end
      it 'Fails if the destination index is not given' do
        payload = create_payload({from: {node: 'test', index: 0}, to: { node: 'test' }})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'index', error: 'required', prefix: 'links[0].to.')
        )
      end
      it 'Fails if the destination index is given as nil' do
        payload = create_payload({from: {node: 'test', index: 0}, to: { node: 'test', index: nil }})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'index', error: 'required', prefix: 'links[0].to.')
        )
      end
      it 'Fails if the destination index is below zero' do
        payload = create_payload({from: {node: 'test', index: 0}, to: { node: 'test', index: -1 }})
        expect { service.build_and_validate!(**payload) }.to raise_error(
          an_instance_of(Modusynth::Exceptions::Service)
          .and having_attributes(key: 'index', error: 'value', prefix: 'links[0].to.')
        )
      end
    end


    # describe 'With an invalid port' do
    #   let!(:payload) do
    #     create_payload({ports: [{name: nil, kind: 'input', target: 'test', index: 0}]})
    #   end
    #   it 'Returns an error with the first key in error' do
    #     expect { service.build_and_validate!(**payload) }.to raise_error(
    #       an_instance_of(Modusynth::Exceptions::Service)
    #       .and having_attributes(key: 'name', error: 'required', prefix: 'ports[0].')
    #     )
    #   end
    # end
    # describe 'With an invalid descriptor UUID for a parameter' do
    #   let!(:payload) do
    #     create_payload({parameters: [{descriptorId: 'unknown', targets: ['test']}]})
    #   end
    #   it 'Returns an error with the first key in error' do
    #     expect { service.build_and_validate!(**payload) }.to raise_error(
    #       an_instance_of(Modusynth::Exceptions::Service)
    #       .and having_attributes(key: 'descriptorId', error: 'unknown', prefix: 'parameters[0].')
    #     )
    #   end
    # end
    # describe 'With an invalid control' do
    #   let!(:payload) do
    #     create_payload({controls: [{component: nil, payload: {}}]})
    #   end
    #   it 'Returns an error with the first key in error' do
    #     expect { service.build_and_validate!(**payload) }.to raise_error(
    #       an_instance_of(Modusynth::Exceptions::Service)
    #       .and having_attributes(key: 'component', error: 'required', prefix: 'controls[0].')
    #     )
    #   end
    # end
  end
end