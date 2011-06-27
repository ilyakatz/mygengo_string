require 'my_gengo_locale_downloader'

#Add a mygengo.yml file to your #{Rails.root.to_s}/config directory with the following lines
#development:
#    token: TOKEN
#    project: PROJECT_NAME
#
#You man optionally add default languages that you would be pulling most often
#development:
#    token: TOKEN
#    project: PROJECT_NAME
#    languages: en,ru
#
#After this is configured you can run the rake task
#    rake mygengo:locale
#
#In addition, if you would like to pull down only specific languages
#
#rake mygengo:locale languages=ru

namespace :mygengo do
  desc "Download locale files from mygengo string account"
  task :locale do
    config_file = "#{Rails.root.to_s}/config/mygengo.yml"

    opts = YAML.load(ERB.new(File.read(config_file)).result)[Rails.env]
    token=opts["token"]
    project=opts["project"]
    langs=opts["languages"] || "en"

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
        gengo = MyGengoLocaleDownloader.new(token, project, language)
        gengo.download_locale_files
      end
    end

  end
end

