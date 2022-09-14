module Modusynth
  module Models
    # A module is what we called a "node" in ancient versions of the application.
    # It has one or several audio inputs, one or several audio outputs, and
    # transforms the sound via a set of voltage-controlled inputs or numeric
    # parameters that can change frequencies, gains, or any over value.
    # @author Vincent Courtois <courtois.vincent@outlook.com>
    class Module
    include Mongoid::Document
    include Mongoid::Timestamps

    belongs_to :synthesizer, class_name: '::Modusynth::Models::Module', inverse_of: :modules
    end
  end
end