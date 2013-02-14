class Star
	attr :set

	def initialize
		@set = nil
	end

	def yes!
		@set = true
	end

	def no!
		@set = false
	end

	def dunno!
		@set = nil
	end

	def to_s
		return "not-set" if @set.nil?
		return "yes" if @set == true
		return "no"
	end
end
