require 'open-uri'
require 'json'
require 'mcquery'

task :query_servers => :environment do
    servers = Server.all.to_a
    queries = Array.new
    stats = Array.new

    servers.each do |server|
        queries << Thread.new(server) do |s|
            result = MCQuery.new(server.ip.to_s, server.port.to_i)

            stats << Thread.new(result) do |r|
                StatHat::API.post_value(s.stathat_key, s.stathat_ukey, r.players_online)
            end
        end
    end

    queries.each do |thread|
        thread.join
    end

    stats.each do |thread|
        thread.join
    end
end

task :update_stathat_data => :environment do
    servers = Server.all.to_a
    stats = Array.new
    stathat = "https://www.stathat.com/x/"

    servers.each do |server|
        stats << Thread.new(server) do |s|
            if s.stathat_short_id == nil
                response = JSON.parse(open(stathat + s.stathat_token + "/stat?name=" + s.id).read)
                s.stathat_short_id = response["id"]
            end

            response = JSON.parse(open(stathat + s.stathat_token + "/data/" + s.stathat_short_id + "?t=1w3h").read)
            s.stathat_data = response[0]["points"]

            s.save
        end
    end

    stats.each do |thread|
        thread.join
    end
end
