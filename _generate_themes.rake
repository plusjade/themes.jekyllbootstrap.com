desc "generate static theme website for all themes"
task :generate_themes do
  require 'jekyll'
  require 'json'
  require 'yaml'
  theme_data = []
  
  Dir.glob("#{CONFIG['themes']}/*") do |theme|
    next unless FileTest.directory?(theme)
    
    # Grab theme data
    settings_file = File.join(theme, "settings.yml")
    if FileTest.exist?(settings_file)
      theme_data << YAML.load_file(settings_file)["theme"]
    end
    
    # Edit configuration to scope to a generated theme sub-directory.
    # Also omit theme folder to avoid recursion ; assets because asset urls are absolute.
    options = Jekyll.configuration({
      "safe" => true,
      "destination" => File.join(SOURCE, "themes", File.basename(theme)),
      "JB" => {
        "BASE_PATH" => "/themes/#{File.basename(theme)}",
        "ASSET_PATH" => "/assets/themes/#{File.basename(theme)}"
      },
    })
    options["exclude"] += ["themes", "assets"]
    
    system "rake switch_theme name='#{File.basename(theme)}'"

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
  
  open(File.join(SOURCE, "themes", "data.json"), "w") do |page|
    page.puts theme_data.to_json
  end
  
  # make sure we switch back to jade-doc theme
  system "rake switch_theme name='twitter'"
end # rake generate_theme_gallery
