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

    def self.from_validation exception, prefix = ''
      self.on_document exception.document, prefix
    end

    def self.from_active_model exception, prefix = ''
      self.on_document exception.model, prefix
    end

    def self.on_document document, prefix
      messages = document.errors.messages
      key = messages.keys.first
      prefix += '.' if prefix != ''
      Modusynth::Exceptions::BadRequest.new("#{prefix}#{key}", messages[key][0])
    end
  end
end