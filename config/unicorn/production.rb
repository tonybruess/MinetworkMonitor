pid "/home/deploy/apps/minetworkmonitor/shared/pids/unicorn.pid"

listen 3001
worker_processes 2
timeout 30
preload_app true
stderr_path "/home/deploy/apps/minetworkmonitor/shared/log/unicorn.err.log"

before_fork do |server, worker|
 	old_pid = "/home/deploy/apps/minetworkmonitor/shared/pids/unicorn.pid.oldbin"
 	if File.exists?(old_pid) && server.pid != old_pid
    	begin
    		Process.kill("QUIT", File.read(old_pid).to_i)
    	rescue Errno::ENOENT, Errno::ESRCH
		end
	end
end
