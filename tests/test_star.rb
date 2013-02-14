require 'test/unit'
require '../star'

class Test_Star < Test::Unit::TestCase

	def setup
		@new_star = Star.new
		@yes_star = Star.new
		@no_star = Star.new
		@yes_star.yes!
		@no_star.no!
	end

	def teardown
		@new_star = nil
	end

	def test_star
		assert_equal(@new_star.to_s, "not-set")
		assert_equal(@yes_star.to_s, "yes")
		assert_equal(@no_star.to_s, "no")
	end

end
