require 'test/unit'
require '../star'
require '../tags'
require '../author'
require '../article'

class Test_Article < Test::Unit::TestCase

	def setup
		author = Author.new("insarra", "insarra@gmail.com", "http://livejournal.com/~insarra")
		star = Star.new
		star.yes!
		tags = Tags.new
		tags.add "world_domination_plan"
		tags.add "draft"
		@article = Article.new("http://livejournal.com/~insarra/12345.html", "[wdp] Tagger Concept немного русского в utf", "blablabla_body_текст", author, tags, star)
	end

	def teardown
		@article = nil
	end

	def test_article
		assert_equal(@article.tags.class, Tags)
		assert_equal(@article.author.class, Author)
		assert_equal(@article.star.class, Star)
		assert_equal(@article.url, "http://livejournal.com/~insarra/12345.html")
		assert_equal(@article.title, "[wdp] Tagger Concept немного русского в utf")
		assert_equal(@article.body, "blablabla_body_текст")
	end

end
