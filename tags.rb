class Tags
	include Enumerable
	attr :tags

	def initialize
		@tags = []
	end

	def add(tag)
		@tags << tag
	end
end
