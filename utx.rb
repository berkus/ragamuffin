###########################################
# Ruby wrapper for UTX Web API.
# (c) 2005, Berkus <berkus@madfire.net>
# Licensed under MIT License.
###########################################

require "cgi"
require "net/http"
require "rexml/document"
include REXML

class Utx
    def initialize(project, email)
		@request_url = "utx.ambience.ru"
		@tags_get = "/api/1.0/url/?"
		@port = 80
		@user_agent = "UtxRubyApi/#{project}; #{email}"
    end

    def tags_for_user(user, sort_by)
    end

    def tags_for_url(url)
		http = Net::HTTP.new(@request_url, @port)
		url = escape(url)
		response = http.get("#{@tags_get}url=#{url}", { "User-Agent" => @user_agent })

		p response.body
		doc = Document.new(response.body)
		p doc
		p doc.root
		w = XPath.first(doc.root, "/tags/warning")
		return [false, w.attributes['name']] if w

		res = {}
		XPath.each(doc.root, "/tags/tag") { |el|
			users = []
			XPath.each(el, "user") { |usr|
				users << usr.attributes['name']
			}
			res[el.attributes['name']] = { :count => el.attributes['count'], :users => users }
		}
		[true, res]
    end

    def urls_for_tag(tag)
    end

	private

	def escape(value)
		return CGI.escape(value)
	end
end

if __FILE__ == $0
	utx = Utx.new("TestSuite", "berkus@madfire.net")
	p utx.tags_for_url("http://www.livejournal.com/users/laslas/103018.html")
	p utx.tags_for_url("kingoleg/294955")
	p utx.tags_for_url("kingoleg/294959")
	p utx.tags_for_url("http://www.example.com/")
end
