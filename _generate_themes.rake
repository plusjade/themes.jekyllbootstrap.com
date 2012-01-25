desc "generate static theme website for all themes"
task :generate_themes do
  require 'jekyll'
  require 'json'
  
  Dir.glob("#{CONFIG['themes']}/*") do |theme|
    next unless FileTest.directory?(theme)
    
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
    
    #puts options.to_yaml
    #abort('a')
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
  
  # make sure we switch back to jade-doc theme
  system "rake switch_theme name='twitter'"
end # rake generate_theme_gallery
