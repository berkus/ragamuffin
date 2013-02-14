class Article
	attr :author
	attr :url
	attr :title
	attr :time
	attr :body
	attr :tags
	attr :star

	def initialize(url, title, body, time, author, tags, star)
		@url, @title, @body, @time, @author, @tags, @star = url, title, body, time, author, tags, star
	end
end
