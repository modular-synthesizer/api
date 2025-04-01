# frozen_string_literal: true

module Modusynth
  module Controllers
    class Experiments < Modusynth::Controllers::Base
      get '/' do
        Mongo::Logger.logger = Logger.new("./logs/#{DateTime.now}.log")
        mods = Modusynth::Models::Module
          .includes(:parameters, :ports)
          .where(synthesizer_id: symbolized_params[:synthesizer_id])
          .to_a
        tool_ids = mods.map(&:tool_id).uniq
        raw_tools = Modusynth::Services::Tools::Find.instance.find_by_ids(ids: tool_ids)
        tools = raw_tools.to_a.to_h { |t| [t.id, t] }
        mods.each do |mod|
          mod.tool = tools[mod.tool_id]
        end
        Mongo::Logger.logger = Logger.new($stdout)
        Mongo::Logger.level = 1
        render_json 'modules/list.json', mods:
      end
    end
  end
end
