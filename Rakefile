# require your app file first
require './abipixlar'
require 'sinatra/activerecord/rake'

task :refresh do
  desc "Pull data from aftonbladet.se"
  doc = Nokogiri::HTML(open("http://www.aftonbladet.se"))
  sizes = Array.new
  doc.css('h2').each do |node|
      size_class = node.attributes['class'].to_s[/abS[0-9]+/]
      unless size_class.nil?
        sizes << size_class[/[0-9]+/].to_i
      end
  end

  sizes.sort!

#  puts sizes.last

  Size.create({size: sizes.last})

  puts 'All done!'
end

task :cron => [:refresh] do
  puts "Cron done!"
end
