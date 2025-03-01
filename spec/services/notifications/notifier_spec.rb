# rubocop:disable Metrics/BlockLength
# frozen_string_literal: true

RSpec.describe Modusynth::Services::Notifications::Notifier do
  let!(:service) { Modusynth::Services::Notifications::Notifier.new('tab_id') }
  let!(:topic) { double(:topic, publish: double(:publish)) }
  let!(:channel) { double(:channel, topic: topic) }
  before do
    allow(service).to receive(:channel).and_return(channel)
  end
  describe 'Classic commands' do
    describe 'No sessions are given' do
      it 'Does not sent notifications' do
        service.command(Commands::ADD_MEMBERSHIP, [], '{"foo":"bar"}')
        expect(topic).to_not have_received(:publish)
      end
    end
    describe 'A session is expired' do
      let!(:account) { create(:random_admin) }
      let!(:session) { double(:session, expired?: true) }
      it 'Does not sent notifications' do
        service.command(Commands::ADD_MEMBERSHIP, [session], '{"foo":"bar"}')
        expect(topic).to_not have_received(:publish)
      end
    end
    describe 'A valid session is given' do
      let!(:account) { create(:random_admin) }
      let!(:session) { create(:session, account:) }
      it 'Sends the notification correctly' do

        service.command(Commands::ADD_MEMBERSHIP, [session], '{"foo":"bar"}')
        expect(topic).to have_received(:publish).with(
          '{"operation":"add.membership","payload":{"foo":"bar","tab_id":"tab_id"}}',
          routing_key: session.token
        )
      end
    end
  end
end

# rubocop:enable Metrics/BlockLength
