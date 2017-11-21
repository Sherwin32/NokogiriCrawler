require 'nokogiri'
require 'pry'
require 'open-uri'

url = "https://www.nytimes.com/"
doc = Nokogiri::HTML(open(url), nil, "UTF-8")
doc.css('.story-heading a').each do |head|
	output_str = head.text
	output_str.sub!(/^\n*\t*\s*/, "").sub!(/\n*\t*\s*$/, "")
	p output_str
end
