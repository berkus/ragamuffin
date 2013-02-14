# Common tags retriever.
require 'ljlib'
require 'technorati'
require 'utx'

class TagsRetriever
    # Collect tags for url from technorati, utx, del.icio.us.
    # Simple implementation, without tag weights.
    def self.tags_from_url(url)
		tags1 = TechnoratiTagsRetriever.tags_from_url(url)
		tags2 = DeliciousTagsRetriever.tags_from_url(url)
		tags3 = UtxTagsRetriever.tags_from_url(url)
		tags4 = LivejournalTagsRetriever.tags_from_url(url)
		[tags1, tags2, tags3, tags4].flatten.uniq
    end

	# Return a hash of tag=>weight pairs.
	# Weight is simply a count of times this tag appears for given url.
	def self.weighted_tags_from_url(url)
		{}
	end

    # Parse body and find possible tags (f.ex. del.icio.us ones).
    def self.tags_from_body(body)
		tags1 = TechnoratiTagsRetriever.tags_from_body(body)
		tags2 = DeliciousTagsRetriever.tags_from_body(body)
		tags3 = UtxTagsRetriever.tags_from_body(body)
		tags4 = LivejournalTagsRetriever.tags_from_body(body)
		[tags1, tags2, tags3, tags4].flatten.uniq
    end
end

class TechnoratiTagsRetriever
    def self.tags_from_url(url)
		rati = Technorati.new("5ec8f3dda95bbaee212fadd0dccb7551")
		resp = rati.blogposttags(url)
		[]
    end

    # Technorati does not provide means to set tags within source document's body.
    def self.tags_from_body(body)
		[]
    end
end

class DeliciousTagsRetriever
    # del.icio.us does not have an api to retrieve arbitrary url's tags.
    def self.tags_from_url(url)
		[]
    end

    def self.tags_from_body(body)
        # XPath.match(//*a[@href~del.icio.us])
		[]
    end
end

class UtxTagsRetriever
    def self.tags_from_url(url)
		utx = Utx.new("ProjectBosatsu", "berkus@madfire.net")
		res, hsh = utx.tags_for_url(url)
		return [] if !res
		return hsh.keys
    end

    def self.tags_from_body(body)
		# XPath.match(//*a[@href~utx.ambience.ru])
		[]
    end
end

class LivejournalTagsRetriever
    def self.tags_from_url(url)
		return [] if url !~ /livejournal.com/
		[]
    end

    def self.tags_from_body(body)
		[]
    end
end
