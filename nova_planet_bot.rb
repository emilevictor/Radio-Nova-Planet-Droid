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

every :minute do

	json = HTTParty.get('http://www.novaplanet.com/radionova/ontheair')

	parsed_json = JSON.parse(json)

	# Now take that wonderful stuff and push it through nokogiri.

	nokogiri_elements = Nokogiri::HTML(parsed_json["track"]["markup"])

	l_artist = nokogiri_elements.css(".artist").text.strip

	l_title = nokogiri_elements.css(".title").text.strip

	if l_artist != artist && l_title != title
		title = l_title
		artist = l_artist

		#GMT
		current_time = Time.now - 36000

		Twitter.update("\"#{title}\" by #{artist} played on Nova Planet FM at #{current_time.strftime("%H:%M %p")} GMT")
	end

end if defined?(Whenever)

return unless __FILE__ == $PROGRAM_NAME

