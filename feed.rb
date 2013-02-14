class Feed
	attr :author
	attr :feed_url
	attr :star
	attr :tags

	def initialize(author, url, star, tags)
		@author, @feed_url, @star, @tags = author, url, star, tags
	end
end
