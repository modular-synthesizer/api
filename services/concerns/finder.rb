module Modusynth
  module Services
    module Concerns
      # A finder service is a service that provide methods to find an
      # instance of the associated model. If the :model method is NOT
      # defined when invoking one of its methods, it will therefore
      # raise an error to indicate you did not implement everything you
      # needed to use this concern.
      #
      # @author Vincent Courtois <courtois.vincent@outlook.com>
      module Finder
        extend ActiveSupport::Concern

        def list **criteria
          check_model_implementation! caller: 'find'
          model.where(**criteria)
        end


        # Tries to find a group given its unique identifier. If it does not
        # find it, fails with a correct esception raised. If the model
        # method is not implemented raises an error to indicate you're not
        # implementing the concern correctly.
        #
        # @param id [string] the unique identifier of the group to find.
        # @raise [::Modusynth::Exceptions::Unknown] when the UUID is not
        #   found in the database.
        # @raise [::Modusynth::Exceptions::Concern] when the concern is not
        #   correctly implemented
        def find_or_fail(id: nil, container: nil, field: 'id', **_)
          raise Modusynth::Exceptions.required(field) if id.nil?
          instance = find(id: id, container:)
          raise Modusynth::Exceptions.unknown(field) if instance.nil?
          instance
        end

        def find(id:, container: nil, **_)
          check_model_implementation! caller: 'find'
          container = model if container.nil?
          container.where(id: id).first
        end

        def find_by(**payload)
          model.find_by(**payload)
        end

        def check_model_implementation! caller:
          unless respond_to? :model, true
            raise Modusynth::Exceptions::Concern.new(caller:, called: 'model')
          end
        end
      end
    end
  end
end