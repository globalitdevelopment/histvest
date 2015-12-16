worker_processes Integer(ENV["WEB_CONCURRENCY"] || 2)
timeout 60
preload_app true
pid "tmp/unicorn.pid"
GC.respond_to?(:copy_on_write_friendly=) and GC.copy_on_write_friendly = true
check_client_connection false

listen "unix:/tmp/unicorn.sock", backlog: 2048, tcp_nopush: false, tcp_nodelay: true

#stderr_path "log/unicorn.log"
#stdout_path "log/unicorn.log"

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect!

  old_pid = "tmp/unicorn.pid.oldbin"
  if File.exists?(old_pid) && server.pid != old_pid
    begin
      Process.kill("QUIT", File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
      # someone else did our job for us
    end
  end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  # reload .env
  require 'dotenv'
  ENV.update Dotenv::Environment.new "#{ENV['HOME']}/.env" if File.exist? "#{ENV['HOME']}/.env"

  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
