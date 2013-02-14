# Read OPML file, read corresponding archives, import them into one big article archive in YAML format.
require 'rexml/document'
require 'rexml/xpath'
require 'yaml'
require 'time'
require 'feed'
require 'star'
require 'tags'
require 'author'
require 'article'

puts "*" * 30, " Reading OPML ", "*" * 30

articles = []

File.open("data/feeds.opml") { |f|

	opml = REXML::Document.new(f)

	REXML::XPath.each(opml, "//*[@xmlUrl]") { |el|

		author = Author.new(el.attributes['title'], nil, el.attributes['htmlUrl'])
		star = Star.new
		tags = Tags.new
		feed = Feed.new(author, el.attributes['xmlUrl'], star, tags)

		puts "Reading feed data for '#{el.attributes['title']}'"

		begin
			File.open("Archive/"+el.attributes['xmlUrl'].gsub(/\/|:/, "_")+".xml") { |xml|

				data = REXML::Document.new(xml)

				REXML::XPath.each(data, "/rss/channel/item") { |item|

					url = item.elements['link'].nil? ? '' : item.elements['link'].text
					title = item.elements['title'].nil? ? '' : item.elements['title'].text
					desc = item.elements['description'].nil? ? '' : item.elements['description'].text
					time = item.elements['pubDate'].nil? ? Time.at(0) : Time.parse(item.elements['pubDate'].text)

					article = Article.new(url, title, desc, time, author, tags, star)

					articles << article

				}

			}
		rescue => e
			puts "...failed because: #{$!}"
			next
		end

	}

}

puts "*" * 30, " Dumping YAML ", "*" * 30

File.open("articles.yaml", "w") { |f|

	YAML::dump(articles, f)

} if articles.length > 0

puts "Done. #{articles.length} records"
