set :environment, "production"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every :day, :at => "1:35am" do
  rake 'daily_option_chains'
end
