
require 'net/http'
require 'uri'

zone_ids = []

Net::HTTP.start("www.wowhead.com") do |http|
	res = http.get "/?zones=2"
	res.body.scan(/\/\?zone=(\d+)/) {|id| zone_ids << id.first.to_i}

	res = http.get "/?zones=3"
	res.body.scan(/\/\?zone=(\d+)/) {|id| zone_ids << id.first.to_i}
	puts "Found #{zone_ids.size} instances and raids"
end

Net::HTTP.start("static.wowhead.com") do |http|
	zone_ids.each do |id|
		res = http.get "/images/maps/enus/zoom/#{id}.jpg"
		open("#{id}.jpg", "wb") {|f| f.write res.body} if res.is_a? Net::HTTPOK
	end
end
