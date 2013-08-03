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

            p "Got result for " + s.name
            p result

            s.last_check = {:protocol_version => result.protocol_version, :server_version => result.server_version, :motd => result.motd, :players_online => result.players_online, :players_max => result.players_max}
            s.save

            stats << Thread.new(result) do |r|
                timeout(3) do
                    p "Posting data for " + s.name
                    p StatHat::API.post_value(s.stathat_key, s.stathat_ukey, r.players_online)
                end
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
            if s.stathat_id == nil
                response = JSON.parse(open(stathat + s.stathat_token + "/stat?name=" + s.id).read)
                s.stathat_id = response["id"]
                p "Set ID for " + s.name + " to " + s.stathat_id
            end

            response = JSON.parse(open(stathat + s.stathat_token + "/data/" + s.stathat_id + "?t=1d15m").read)
            s.stathat_data = response[0]["points"]

            p "Fetched data for " + s.name + " (" + s.stathat_data.length.to_s + ")"

            s.save
        end
    end

    stats.each do |thread|
        thread.join
    end
end
