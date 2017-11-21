## <img src="https://avatars2.githubusercontent.com/u/210414?v=4&s=200" height="20px"> Ruby Gem: `Nokogiri`

### **GEM: Nokogiri**

The **Nokogiri** gem is an open source software library to parse HTML and XML in Ruby and It's a cool choice to do web crawling with. Web scraping is a programmatic method of extracting data from websites. When you browse the web you consume a ton of publicly available information.  As a user, all of this information is presented to you as unstructured data in the form of HTML documents.
Now imagine, what if you could take all of these pages and turn them into structured data, **`pick out the pieces you like`** and export it all to a database or spreadsheet?
<br>
<img src="https://media.giphy.com/media/l0HlFOlbKxx1BjzO0/giphy.gif" height="200">

Check out [**`this link`**](https://www.distilled.net/resources/web-scraping-with-ruby-and-nokogiri-for-beginners/) I found for more information or go to [**`my github repo`**](https://github.com/Sherwin32/NokogiriCrawler) for the complete code for following intro.

**note:** Nokogiri also has the meaning of Japanese saw(鋸) :
<br>
<img src="http://www2u.biglobe.ne.jp/~tyouken/dougu/d6.jpg" height="300">
<img src="https://media.giphy.com/media/HLXEYBMbEAXPW/giphy.gif" height="300">

In the Gemfile, add the following lines:
```ruby
source 'https://rubygems.org'

gem 'nokogiri' #for parsing HTML or XML files
gem 'open-uri' #a tool to access web page through your ruby file
gem 'pry' #to beautify your terminal view
```
In your CLI, don't forget to `bundle` or `bundle install`!

Here is an example to parse HTML file using url:
```ruby
require 'nokogiri'
require 'open-uri'

url = "https://www.nytimes.com/"
doc = Nokogiri::HTML(open(url))
```

In the example above, I retrieved the homepage html of New York Times and assigned it to the variable `doc`.
Nokogiri has four basic rules for CSS selector:
* HTML tag selector
* id selector
* class selector
* attribute selector

For example, if we see html like:
```html
<div class="hi" id="div-one" width="500"></div>
```
We can see it as:
```html
<tag class="class-value" id="id-value" attribute="attribute"></tag>
```
So the way we use the CSS selector would be like:
```ruby
doc = Nokogiri::HTML(open(YOUR_URL_TO_BROWSE), nil, "UTF-8")
doc.css('div.hi#div-one[width="500"]')
```

Now we've know enough to select and manipulate the `doc`, let's go back to the New York Times homepage and dig into the developer tool:
<img src="https://i.imgur.com/ZtjflsH.jpg">
Let's try to crawl through it by retrieving all the `article` tags from the homepage. With `each` `article` tag we get, generate a hash with text inside `story-heading` class, `byline` class and `summary` class, and finally return a json file:
```ruby
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
```
Hurray! Now we've crawled through the New York Times homepage and generated a .json file named `nytimes.json`.

Here's a fraction of the .json file we're supposed to get:
```json
  [{
    "heading": "59,000 Haitians to Lose Protected Status in the U.S.",
    "byline": "By MIRIAM JORDAN 7:51 PM ET",
    "summary": "The Trump administration said it would revoke a program that has let Haitians live and work legally here after a 2010 earthquake. Those affected must leave by July 2019 or face deportation."
  },
  {
    "heading": "Charlie Rose Made Sexual Advances, Multiple Women Say",
    "byline": "By KIM BARKER and ELLEN GABLER 9:16 PM ET",
    "summary": "Allegations by women who worked with Mr. Rose over a dozen years led CBS to suspend him from its morning program and PBS to stop distributing his interview show."
  },
  {
    "heading": "When Politicians Use the Old ‘I’m an Entertainer’ Defense",
    "byline": "By JAMES PONIEWOZIK 6:32 PM ET",
    "summary": "Men get away with bad behavior under the guise of show business in both comedy and politics. Too often, women are just the material."
  }]
```

**Note:** `doc.css('article')` would return an array of Nokogiri object. You can use any built in method for Array object in Ruby on it, but don't forget to use **`.text`** or other Nokogiri meghod to get the information you want.

**Thank you for reading**