require 'nokogiri'
require 'pry'
require 'open-uri'
require 'json' # A tool to make beautiful json file

url = "https://www.nytimes.com/"
posts = []
doc = Nokogiri::HTML(open(url), nil, "UTF-8")
doc.css('article').each do |story|
	head = story.css('.story-heading')
	byline = story.css('.byline')
	summary = story.css('.summary')
	if head.text == "" then next end
	output_head = head.text
	output_head.sub!(/^\n*\t*\s*/, "").sub!(/\n*\t*\s*$/, "")
	output_byline = byline.text
	output_summary = summary.text.sub!(/^\n*\t*\s*/, "").sub!(/\n*\t*\s*$/, "")
	posts.push({
		:heading => output_head,
		:byline => output_byline,
		:summary => output_summary
	})
end

File.open('nytimes.json', 'w') {|file| file.write(JSON.pretty_generate(posts))}

# posts.each do |post|
# 	puts post[:heading]
# end
