# frozen_string_literal: true

module Modusynth
  module Exceptions
    autoload :BadRequest, './exceptions/bad_request'
    autoload :Concern, './exceptions/concern'
    autoload :Forbidden, './exceptions/forbidden'
    autoload :Service, './exceptions/service'
    autoload :ServiceWithoutModel, './exceptions/service_without_model'
    autoload :Unknown, './exceptions/unknown'
    autoload :Validation, './exceptions/validation'

    def self.required(field)
      raise Modusynth::Exceptions::BadRequest.new(field, 'required')
    end

    def self.unknown(field = 'id')
      raise Modusynth::Exceptions::Unknown.new(field, 'unknown')
    end

    def self.forbidden(field = 'auth_token')
      raise Modusynth::Exceptions::Forbidden.new(field, 'forbidden')
    end

    def self.from_validation(exception, prefix = '')
      on_document exception.document, prefix
    end

    def self.from_active_model(exception, prefix = '')
      on_document exception.model, prefix
    end

    def self.on_document(document, prefix)
      messages = document.errors.messages
      key = messages.keys.first
      prefix += '.' if prefix != ''
      Modusynth::Exceptions::BadRequest.new("#{prefix}#{key}", messages[key][0])
    end
  end
end
