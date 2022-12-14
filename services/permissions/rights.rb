module Modusynth
  module Services
    module Permissions
      class Rights
        include Singleton
        include Modusynth::Services::Concerns::Finder
        include Modusynth::Services::Concerns::Deleter

        def create label: nil
          record = model.new(label: label)
          record.save!
          record
        end

        def list
          model.all.sort(label: 1).to_a
        end

        private

        def model
          Modusynth::Models::Permissions::Right
        end
      end
    end
  end
end