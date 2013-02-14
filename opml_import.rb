# Read OPML file, import feeds structure into our YAML format
require 'rexml/document'
require 'rexml/xpath'
require 'yaml'
require 'feed'
require 'star'
require 'tags'
require 'author'

puts "*" * 80

feeds = []

File.open("data/feeds.opml") { |f|

	opml = REXML::Document.new(f)

	REXML::XPath.each(opml, "//*[@xmlUrl]") { |el|

		author = Author.new(el.attributes['title'], nil, el.attributes['htmlUrl'])
		star = Star.new
		tags = Tags.new
		feed = Feed.new(author, el.attributes['xmlUrl'], star, tags)
		p feed
		feeds << feed

	}

}

File.open("feeds.yaml", "w") { |f|

	YAML::dump(feeds, f);

} if feeds.length > 0
