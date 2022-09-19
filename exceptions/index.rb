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

    def self.from_validation exception
      messages = exception.document.errors.messages
      key = messages.keys.first
      Modusynth::Exceptions::BadRequest.new(key: key, error: messages[key][0])
    end
  end
end