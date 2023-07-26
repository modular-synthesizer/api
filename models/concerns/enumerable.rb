module Modusynth
    module Models
      module Concerns
        # Defines enumerations for the Mongoid models. An enumeration is a field that can only use a given set of values.
        # @author Vincent Courtois <courtois.vincent@outlook.com>
        module Enumerable
          extend ActiveSupport::Concern
  
          # Submodule holding all the static methods add to the current subclass.
          # @author Vincent Courtois <courtois.vincent@outlook.com>
          module ClassMethods
            
            # Creates the field with the given name, set of possible values, and options.
            # @param field_name [String] the name of the enumerated field.
            # @param values [Array<Symbol>] the possible values of the enumerated field.
            # @param options [Hash<Symbol, Any>] the possible options for the field.
            def enum_field(field_name, values, options = {})
              returned = field :"enum_#{field_name}", type: Symbol, default: options[:default]
  
              validates :"enum_#{field_name}", inclusion: {in: values.map(&:to_sym), message: 'inclusion'}
  
              define_method field_name do
                return self["enum_#{field_name}"]
              end
  
              define_method "#{field_name}=" do |value|
                if values.include? value.to_sym
                  self["enum_#{field_name}"] = value.to_sym
                end
              end
  
              values.map(&:to_sym).each do |value|
                define_method "#{field_name}_#{value}!" do
                  self["enum_#{field_name}"] = value
                end
  
                define_method "#{field_name}_#{value}?" do
                  self["enum_#{field_name}"] == value
                end
              end
  
              # This is to make enumerations historizable by
              # returning the field object created by Mongoid.
              returned
            end
          end
        end
      end
    end
  end