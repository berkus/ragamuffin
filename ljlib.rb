#!/usr/local/bin/ruby

##################################################
#
# $ljlib.rb$ $3:43 PM 9/1/2004$
#
# A Ruby interface to LiveJournal. I started
# implementing all the protocol modes but got
# bored. Use this code with caution; it's not very
# well tested.
#
# <http://premshree.livejournal.com/>
#
##################################################

require 'cgi'
require 'xmlrpc/client'

class LJ
	def initialize(lj_server)
		@lj_server 	= lj_server
		@path		= "/interface/xmlrpc"
	end
	
	def callLJ(action, hsh)
		server = XMLRPC::Client.new(@lj_server, @path, 80)
		begin
			ret = server.call("LJ.XMLRPC." + action, hsh)
		rescue XMLRPC::FaultException => e
			puts "Error:"
			puts e.faultCode
			puts e.faultString
		end
		return ret
	end
	
	def escape(hsh)
		hsh.each do |key, value|
			if value.class == Array
#			    value.each_with_index { |x,idx|
#				value[idx] = CGI.escape(x)
#			    }
			    hsh[key] = value
			else
			    hsh[key] = CGI.escape(value)
			end
		end
	end
	
	def checkfriends(user, password, ver="1", mask="0")
		hsh = {
			"mode" 		=> "checkfriend",
			"username"	=> user,
			"password"	=> password,
			"ver"		=> ver,
			"mask"		=> mask
		}
		callLJ("checkfriends", escape(hsh))
	end
	
	def editevent(user, password, itemid, event="", subject="", usejournal=user, security="public", ver="1", allowmask="0")
		hsh = {
			"mode" 		=> "editevent",
			"username"	=> user,
			"password"	=> password,
			"ver"		=> ver,
			"itemid"	=> itemid,
			"event"		=> event,
			"lineendings"	=> "pc",
			"subject"	=> subject,
			"security"	=> security,
			"allowmask"	=> allowmask,
			"usejournal"	=> usejournal,
			"year"		=> "#{Time.now.year}",
			"mon"		=> "#{Time.now.mon}",
			"day"		=> "#{Time.now.day}",
			"hour"		=> "#{Time.now.hour}",
			"min"		=> "#{Time.now.min}"
		}
		puts callLJ("editevent", hsh)
	end
	
	def postevent(user, password, event="", subject="", usejournal=user, security="public", ver="1", allowmask="0")
		hsh = {
			"mode" 		=> "postevent",
			"username"	=> user,
			"password"	=> password,
			"ver"		=> ver,
			"event"		=> event,
			"lineendings"	=> "pc",
			"subject"	=> subject,
			"security"	=> security,
			"allowmask"	=> allowmask,
			"usejournal"	=> usejournal,
			"year"		=> "#{Time.now.year}",
			"mon"		=> "#{Time.now.mon}",
			"day"		=> "#{Time.now.day}",
			"hour"		=> "#{Time.now.hour}",
			"min"		=> "#{Time.now.min}"
		}
		puts callLJ("postevent", hsh)
	end
	
	def editfriends(user, password, add={}, delete = [], ver="1")
		hsh = {
			"mode" 		=> "editfriends",
			"username"	=> user,
			"password"	=> password,
			"ver"		=> ver,
			"delete"	=> delete,
			"add"		=> add
		}
		puts callLJ("editfriends", hsh)
	end
	
	def friendof(user, password, ver="1", friendoflimit="0")
		hsh = {
			"mode" 			=> "friendof",
			"username"		=> user,
			"password"		=> password,
			"ver"			=> ver,
			"friendoflimit"	=> friendoflimit
		}
		puts callLJ("friendof", hsh)
	end
	
	def getdaycounts(user, password, ver="1", usejournal=user)
		hsh = {
			"mode" 		=> "friendof",
			"username"	=> user,
			"password"	=> password,
			"ver"		=> ver,
			"usejournal"	=> usejournal
		}
		puts callLJ("getdaycounts", hsh)
	end
	
	def getevents(user, password, ver="1", usejournal=user)
		hsh = {
			"mode" 		=> "friendof",
			"username"	=> user,
			"password"	=> password,
			"ver"		=> ver,
			"usejournal"	=> usejournal
		}
		puts callLJ("getevents", hsh)
	end

	def consolecommand(user, password, commands, ver="1")
		hsh = {
			"mode" 		=> "checkfriend",
			"username"	=> user,
			"password"	=> password,
			"ver"		=> ver,
			"commands"	=> [commands].flatten
		}
		puts callLJ("consolecommand", escape(hsh))
	end
end
