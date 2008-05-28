
require 'net/http'
require 'uri'

zone_ids = []
coords = {}

Net::HTTP.start("www.wowhead.com") do |http|
	res = http.get "/?zones=2"
	res.body.scan(/\/\?zone=(\d+)/) {|id| zone_ids << id.first.to_i}

	res = http.get "/?zones=3"
	res.body.scan(/\/\?zone=(\d+)/) {|id| zone_ids << id.first.to_i}
	puts "Found #{zone_ids.size} instances and raids"

	zone_ids.each do |id|
		coords[id] = []
		res = http.get "/?zone=#{id}"
		res.body.scan(/\[([\d.]+),([\d.]+),\{label:'([^']*)',type:'([^']*)'\}\]/) {|m| coords[id] << m.join("_")}
		res.body.scan(/\[([\d.]+),([\d.]+),\{label:'([^<']*)',url:'[^']+'\}\]/) {|m| coords[id] << m.join("_")}
		res.body.scan(/\[([\d.]+),([\d.]+),\{label:'<b class="q">([^<]*)<\/b>/) {|m| coords[id] << m.join("_")}
	end

	coords = [*coords].reject {|c| c[1].empty?}.map {|c| "#{c[0]}:#{c[1].join("|")}"}.join("\n").gsub("\\'", "'")
	open("Coords.lua", "wb") {|f| f << "local coords = [[\n" << coords << "\n]]\n"}
end

Net::HTTP.start("static.wowhead.com") do |http|
	zone_ids.each do |id|
		res = http.get "/images/maps/enus/zoom/#{id}.jpg"
		open("Images/#{id}.jpg", "wb") {|f| f.write res.body} if res.is_a? Net::HTTPOK
	end
end
