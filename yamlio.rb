require 'star'
require 'tags'
require 'author'
require 'article'
require 'yaml'

author = Author.new("insarra", "insarra@gmail.com", "http://livejournal.com/~insarra")
star = Star.new
star.yes!
tags = Tags.new
tags.add "world_domination_plan"
tags.add "draft"
article = Article.new("http://livejournal.com/~insarra/12345.html", "[wdp] Tagger Concept немного русского в utf", "blablabla_body_текст", author, tags, star)

tags2 = Tags.new
tags2.add "life"
tags2.add "icq"
star2 = Star.new
article2 = Article.new("http://livejournal.com/~insarra/12456.html", "life | icq", "blablabla_body_текст2", author, tags2, star2)

articles = [article, article2]

File.open("testdump.yaml", "w") do |file|
	YAML::dump(articles, file)
end
