class ApplicationController < ActionController::Base
	protect_from_forgery with: :exception

	def index
	end

	def results
		servers = Server.all.to_a
		result = Array.new

		servers.each do |s|
			result << {:name => s.name, :ip => s.ip, :players_online => s.last_check["players_online"].to_i}
		end

		return render :json => result
	end
end
