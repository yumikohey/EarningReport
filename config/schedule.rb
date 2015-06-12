set :environment, "production"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every :day, :at => "7am" do
  rake 'daily_option_chains'
end

every :day, :at => "12:50am" do
  rake 'daily_option_chains'
end
