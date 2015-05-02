@dir = File.expand_path('../..', __FILE__)

worker_processes `cat /proc/cpuinfo | grep processor | wc -l`.to_i
working_directory @dir

timeout 30
preload_app true

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end
end 
