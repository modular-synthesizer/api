module Modusynth
  module Controllers
    class Generators < Modusynth::Controllers::Base
      api_route 'get', '/', authenticated: false do
        folder = File.absolute_path(File.join('.', 'public', 'generators'))
        results = (Dir.entries(folder) - ['.', '..']).map do |filename|
          filename.gsub(/\.js/, '')
        end

        halt 200, results.sort.to_json
      end

      api_route 'get', '/:name', authenticated: false do
        path = File.absolute_path(File.join('.', 'public', 'generators', "#{params[:name]}.js"))
        unless File.file? path
          raise Modusynth::Exceptions.unknown 'name'
        end
        halt 200, File.read(path)
      end
    end
  end
end