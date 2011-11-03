require 'my_gengo_locale_downloader'

namespace :mygengo do
  desc "Download locale files from mygengo string account"
  task :locale do
    config_file = "#{Rails.root.to_s}/config/mygengo.yml"

    opts = YAML.load(ERB.new(File.read(config_file)).result)[Rails.env]
    token=opts["token"]
    project=opts["project"]
    langs=opts["languages"] || "en"
    extention=opts["extension"] || "yml"

    if token.nil?
      puts "!!!Please provide token in #{config_file}"
    elsif project.nil?
      puts "!!!Please provide project name in #{config_file}"
    else
      if ENV['languages']
        languages = ENV['languages']
      elsif langs
        languages = langs
      else
        languages = "en"
      end
      languages.split(",").each do |language|
        gengo = MyGengoLocaleDownloader.new(token, project, language, "tmp/locale",  extention)
        gengo.download_locale_files
      end
    end

  end
end