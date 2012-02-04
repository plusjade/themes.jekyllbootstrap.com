desc "generate static theme website for all themes"
task :generate_themes do
  require 'jekyll'
  require 'json'
  require 'yaml'
  theme_data = []
  namespace = "preview" # folder all themes are namespaced into.
  
  theme_packages = File.join(SOURCE, "_theme_packages")
  
  Dir.glob("#{theme_packages}/*") do |package|
    next unless FileTest.directory?(package)

    manifest = verify_manifest(package)
    theme_data << manifest
    theme = manifest["name"]
    
    
    # Edit configuration to scope to a generated theme sub-directory.
    # Also omit theme folder to avoid recursion ; assets because asset urls are absolute.
    options = Jekyll.configuration({
      "safe" => true,
      "destination" => File.join(SOURCE, namespace, manifest["name"]),
      "JB" => {
        "BASE_PATH" => "/#{namespace}/#{manifest["name"]}",
        "ASSET_PATH" => "/assets/themes/#{manifest["name"]}"
      },
    })
    options["exclude"] += [namespace, "assets"]
    
    system "rake switch_theme name='#{manifest["name"]}'"

    puts "Building site: #{options['source']} -> #{options['destination']}"
    begin
      Jekyll::Site.new(options).process
    rescue Jekyll::FatalException => e
      puts
      puts "ERROR: YOUR SITE COULD NOT BE BUILT:"
      puts "------------------------------------"
      puts e.message
      exit(1)
    end
    puts "Successfully generated site: #{options['source']} -> #{options['destination']}"
  end
  
  open(File.join(SOURCE, namespace, "data.json"), "w") do |page|
    page.puts theme_data.to_json
  end
  
  # make sure we switch back to jade-doc theme
  system "rake switch_theme name='twitter'"
end # rake generate_theme_gallery
