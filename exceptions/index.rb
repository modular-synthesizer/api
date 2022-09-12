module Modusynth
  module Exceptions
    autoload :BadRequest, './exceptions/bad_request'
    autoload :Unknown, './exceptions/unknown'

    def self.required field
      raise Modusynth::Exceptions::BadRequest.new(field, 'required')
    end

    def self.unknown field
      raise Modusynth::Exceptions::Unknown.new(field, 'unknown')
    end
  end
end