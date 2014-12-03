require 'rubygems'
require 'sinatra'
require 'json'

# IRC Config
IRC_HOST = ENV['IRC_HOST'] || 'irc.freenode.org'
IRC_PORT = ENV['IRC_PORT'] || 6667
IRC_CHANNEL = ENV['IRC_CHANNEL'] ||  '#yourchannel'
IRC_NICK = ENV['IRC_NICK'] || 'GitLabBot'
IRC_REALNAME = ENV['IRC_REALNAME'] || 'GitLabBot'

post '/commit' do

  Thread.new do
    socket = TCPSocket.open(IRC_HOST, IRC_PORT)
    socket.puts("NICK #{IRC_NICK}")
    socket.puts("USER #{IRC_NICK} 8 * : #{IRC_REALNAME}")
    #socket.puts("JOIN #{IRC_CHANNEL}") # don't join, just send the msg directly

    json = JSON.parse(request.env["rack.input"].read)

    socket.puts "PRIVMSG #{IRC_CHANNEL} :New Commits for '" + json['repository']['name'] + "'"

    json['commits'].each do |commit|
      socket.puts "PRIVMSG #{IRC_CHANNEL} :by #{commit['author']['name']} | #{commit['message']} | #{commit['url']}"
    end

    puts socket.gets
    socket.close

    Thread.stop
  end

end
