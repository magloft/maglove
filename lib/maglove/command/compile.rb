module MagLove
  module Command
    class Compile
      include Commander::Methods
      
      def run
        
        task :coffee, theme: "!" do |args, options|
          asset = theme_asset("theme.coffee", options.theme)
          debug("▸ created #{asset.logical_path}") if asset.write!
        end
        
        task :css, theme: "!" do |args, options|
          if File.exists?(theme_path("theme.scss", options.theme))
            asset = theme_asset("theme.scss", options.theme)
          else
            asset = theme_asset("theme.less", options.theme)
          end
          debug("▸ created #{asset.logical_path}") if asset.write!
        end
  
        task :yaml, theme: "!" do |args, options|
          asset = theme_asset("theme.yml", options.theme)
          debug("▸ created #{asset.logical_path}") if asset.write!
        end
  
        task :templates, theme: "!", bucket: "localhost:3002" do |args, options|
          Hamloft::Options.defaults[:asset_uri] = "http://#{options.bucket}"
          theme_glob("templates/*.{html,haml,twig}", options.theme).each do |file|
            # check if yaml file exists
            locals = {}
            locals_contents = theme_contents(file.sub(/\.[^.]+\z/, ".yml"), options.theme)
            if locals_contents
              locals = YAML.load(locals_contents).with_indifferent_access
            end
            asset = theme_asset(file, options.theme, locals)
            debug("▸ created #{asset.logical_path}") if asset.write!
          end
        end

      end
    end
  end
end
