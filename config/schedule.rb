# every :day, :at => '3:25 pm' do

set :environment, "production"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every :day, :at => '12:35 am' do
  rake 'daily_option_chains'
end
