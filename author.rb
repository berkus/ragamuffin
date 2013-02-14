# при наличии емейлов авторы матчатся по ним, при отсутствии - по урлам блогов, и далее по никам.

class Author
	attr :name
	attr :email
	attr :url

	def initialize(name, email, blog_url)
		@name, @email, @url = name, email, blog_url
	end
end
