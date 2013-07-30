require 'rubygems'
require 'json'
require 'httparty'
require 'nokogiri'
require 'whenever'
require 'twitter'


Twitter.configure do |config|
  config.consumer_key = '3UgMrngeV9NFQvjCfODDxg'
  config.consumer_secret = '2jOPuGP0VLJf4a82qQ5ebladMHdAKwo4gO30EIDg'
  config.oauth_token = '1632872857-LktquFlcgkeLlGM7FHCVtnRvZBP8UjbhrC8nNlB'
  config.oauth_token_secret = '6IjVhoW5vwgOnQdcapU8L0s3JhSdE4Q8JCVyx6mtc'
end

title = ''
artist = ''

File.open("currentArtist.txt", 'w') {|f| f.write('') }
File.open("currentTitle.txt", 'w') {|f| f.write('') }

while true

	json = HTTParty.get('http://www.novaplanet.com/radionova/ontheair')

	parsed_json = JSON.parse(json)

	# Now take that wonderful stuff and push it through nokogiri.

	nokogiri_elements = Nokogiri::HTML(parsed_json["track"]["markup"])

	l_artist = nokogiri_elements.css(".artist").text.strip

	l_title = nokogiri_elements.css(".title").text.strip

	artist = File.read('currentArtist.txt')
	title = File.read('currentTitle.txt')

	if l_artist != artist && l_title != title && l_title != "Titre non disponible"
		title = l_title
		artist = l_artist

		File.open("currentArtist.txt", 'w') {|f| f.write('') }
		File.open("currentTitle.txt", 'w') {|f| f.write('') }

		#GMT
		current_time = Time.now - 36000

		Twitter.update("\"#{title}\" by #{artist.capitalize} played on Nova Planet FM at #{current_time.strftime("%H:%M %p")} GMT")
		puts "\"#{title}\" by #{artist.capitalize} played on Nova Planet FM at #{current_time.strftime("%H:%M %p")} GMT"
	else
		current_time = Time.now - 36000

		puts "Didn't post: \"#{l_title}\" by #{l_artist.capitalize} played on Nova Planet FM at #{current_time.strftime("%H:%M %p")} GMT"
	end

	sleep(60)
end