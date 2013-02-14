# Read YAML archive, retrieve tags for each article, write back a new archive with tags.
require 'yaml'
require 'time'
require 'feed'
require 'star'
require 'tags'
require 'author'
require 'article'
require 'thread'
require 'tags_retriever'

puts "*" * 30, " Reading YAML ", "*" * 30

# Url => tags[] mapping
tags = {}

articles = YAML.load_file("articles.yaml")

puts "*" * 30, " Reading tags ", "*" * 30

articles.each { |article|
	puts "--> #{article.url}"
	tags[article.url] = [TagsRetriever.tags_from_url(article.url), TagsRetriever.tags_from_body(article.body)].flatten.uniq
	
	File.open("work/#{article.url.gsub(/[#?:\/]/, "_")}", "w") { |f|
	    YAML::dump(tags[article.url], f)
	}
}

puts "Total #{articles.length} records."
puts "Total #{tags.length} records with tags."

File.open("tags.yaml", "w") { |f|
    YAML::dump(tags, f)
} if tags.length > 0
