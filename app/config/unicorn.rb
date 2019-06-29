# coding: utf-8
app_root = File.expand_path('../../', __FILE__)

ENV['BUNDLE_GEMFILE'] = app_root + "/Gemfile"

log_path = ENV['UNICORN_LOG_PATH']
pid_path = ENV['UNICORN_PID_PATH']
listen_env = ENV['UNICORN_SOCKET_TYPE'] == 'UNIX' ? "#{pid_path}/unicorn.sock" : 3000

worker_processes ENV['UNICORN_WORKER_PROCESSES'].to_i

working_directory app_root

timeout ENV['UNICORN_TIMEOUT'].to_i

stdout_path "#{log_path}/stdout.log"
stderr_path "#{log_path}/stderr.log"

listen listen_env
pid "#{pid_path}/unicorn.pid"

preload_app true

before_fork do |server, worker|
  defined?(ActiveRecord::Base) and
      ActiveRecord::Base.connection.disconnect!

  old_pid = "#{server.config[:pid]}.oldbin"
  if old_pid != server.pid
    begin
      sig = (worker.nr + 1) >= server.worker_processes ? :QUIT : :TTOU
      Process.kill(sig, File.read(old_pid).to_i)
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end

after_fork do |server, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end
