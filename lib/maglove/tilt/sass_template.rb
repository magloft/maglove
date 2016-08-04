module MagLove
  module Tilt
    class SassTemplate < ::Tilt::Template
      self.default_mime_type = 'theme/html'

      def prepare
        @options = options.merge({
          style: :nested,
          load_paths: [],
          cache: false,
          cache_location: nil,
          syntax: :sass,
          filesystem_importer: Sass::Importers::Filesystem
        })
      end
    
      def evaluate(scope, locals, &block)
        prepared_data = "@base: \"#{locals[:base_path].sub("src/", "../../")}\";\n#{data}"
        engine = Sass::Engine.new(prepared_data, @options)
        @output ||= engine.render
      end
    end
  end
end
