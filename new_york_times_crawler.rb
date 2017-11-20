require 'nokogiri'
require 'pry'
require 'open-uri'

url = "https://www.nytimes.com/"
doc = Nokogiri::HTML(open(url))
doc.css('.story-heading a').each do |head|
	a = head.text.sub!(/^\n*\t*\s*/, "")
	b = a.sub!(/\n*\t*\s*$/, "")
	p b
	# p head.text
end

# t = doc.css('.story-heading a').first
# p t.text
# p t.text.sub(/^\n*\t*\s*/, "")