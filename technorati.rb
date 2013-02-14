#########################################################
#
# Ruby wrapper for Technorati's Web API
#
# Copyright (C) 2004, Premshree Pillai.
# $technorati_rb.rb$ $5:57 PM 9/29/2004$
#
# Extended with blogposttags method. 2005.10.18 berkus
# Copyright (C) 2005, Berkus
#
#########################################################

require "cgi"
require "net/http"
require "rexml/document"
include REXML

class Technorati
	def initialize(license_key)
		@license_key = license_key
		@technorati_url = "api.technorati.com"
		@cosmos_get = "/cosmos?"
		@bloginfo_get = "/bloginfo?"
		@outbound_get = "/outbound?"
		@blogposttags_get = "/blogposttags?"
		@port = 80
	end

	private

	def escape(value)
		return CGI.escape(value)
	end

	def populate_weblog_result_items(xml_string, args)
		result = {}
		doc = Document.new(xml_string)
		args.each { |arg|
			doc.elements.each("tapi/document/result/weblog/#{arg}") { |element|
				result[arg] = element.text
			}
		}
		return result
	end

	def populate_item_weblog_items(xml_string, args)
		result = []
		doc = Document.new(xml_string)
		args.each { |arg|
			count = 0
			doc.elements.each("tapi/document/item/weblog/#{arg}") { |element|
				if count == 0
					result << {
						"#{arg}" => element.text
					}
				else
					result[count][arg] = element.text
					count  = count + 1
				end
			}
		}
		return result
	end

	def check_error(xml_string)
		doc = Document.new(xml_string)
		doc.elements.find('tapi/document/result/error') { |element|
			return [true, element.text]
		}
		return [false, '']
	end

	def get_commoninfo(xml_string)
		result = {
			'url'		=> '',
		}

		check, err = check_error(xml_string)
		if !check
			result['error'] = err
			return result
		end

		doc = Document.new(xml_string)
		doc.elements.each('tapi/document/result/url') { |element|
			result['url'] = element.text
		}
		args = ['name', 'url', 'rssurl', 'atomurl', 'inboundblogs', 'inboundlinks', 'lastupdate', 'rank']
		result['weblog'] = populate_weblog_result_items(xml_string, args)
		return result
	end

	public

	# Technorati Link Cosmos
	def cosmos(url, start=0, format="xml")
		http = Net::HTTP.new(@technorati_url, @port)
		url = escape(url)
		response = http.get("#{@cosmos_get}key=#{@license_key}&start=#{start}&url=#{url}&format=#{format}")
		xml_string = response.body
		result = get_commoninfo(xml_string)
		doc = Document.new(xml_string)
		args = ['name', 'url', 'rssurl', 'atomurl', 'inboundblogs', 'inboundlinks', 'lastupdate']
		item_weblog = populate_item_weblog_items(xml_string, args)
		nearestpermalink = []
		excerpt = []
		linkcreated = []
		linkurl = []
		doc.elements.each('tapi/document/item/nearestpermalink') { |element|
				nearestpermalink << element.text
		}
		doc.elements.each('tapi/document/item/excerpt') { |element|
				excerpt << element.text
		}
		doc.elements.each('tapi/document/item/linkcreated') { |element|
				linkcreated << element.text
		}
		doc.elements.each('tapi/document/item/linkurl') { |element|
				linkurl << element.text
		}

		return_hsh = {
			'result'		=> result,
			'item_weblog'		=> item_weblog,
			'nearestpermalink'	=> nearestpermalink,
			'excerpt'		=> excerpt,
			'linkcreated'		=> linkcreated,
			'linkurl'		=> linkurl,
		}
		return return_hsh
	end

	# Blog Information
	def bloginfo(url, format="xml")
		http = Net::HTTP.new(@technorati_url, @port)
		url = escape(url)
		response = http.get("#{@bloginfo_get}key=#{@license_key}&url=#{url}&format=#{format}")
		xml_string = response.body
		return get_commoninfo(xml_string)
	end

	# Outbound Links
	def outbound(url, format="xml")
		item_weblog = []
		http = Net::HTTP.new(@technorati_url, @port)
		url = escape(url)
		response = http.get("#{@outbound_get}key=#{@license_key}&url=#{url}&format=#{format}")
		xml_string = response.body
		result = get_commoninfo(xml_string)
		doc = Document.new(xml_string)
		args = ['name', 'url', 'rssurl', 'atomurl', 'inboundblogs', 'inboundlinks', 'lastupdate']
		item_weblog = populate_item_weblog_items(xml_string, args)
		return_hsh = {
			'result'	=> result,
			'item_weblog'	=> item_weblog,
		}
		return return_hsh
	end

	# Posting Tags
	def blogposttags(url, format="xml")
		http = Net::HTTP.new(@technorati_url, @port)
		url = escape(url)
		response = http.get("#{@blogposttags_get}key=#{@license_key}&url=#{url}&format=#{format}")
		xml_string = response.body
		puts "received:", xml_string
		result = get_commoninfo(xml_string)
		if result['error']
			return result
		end
		doc = Document.new(xml_string)
		p doc
		p doc.root
		p doc.elements
		doc.elements.each("tapi/document/item") { |element|
			p element
		}
	end
end
