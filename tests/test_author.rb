require 'test/unit'
require '../author'

class Test_Author < Test::Unit::TestCase

	def setup
		@author = Author.new("insarra", "insarra@gmail.com", "http://livejournal.com/~insarra")
	end

	def teardown
		@author = nil
	end

	def test_author
		assert_not_equal(@author.name, nil)
		assert_not_equal(@author.email, nil)
		assert_not_equal(@author.url, nil)
		assert_equal(@author.name, "insarra")
		assert_equal(@author.email, "insarra@gmail.com")
		assert_equal(@author.url, "http://livejournal.com/~insarra")
	end

end
