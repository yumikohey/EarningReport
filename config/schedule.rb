set :environment, "production"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every :weekday => "9:00pm" do
  rake 'daily_option_chains'
end

every :weekday => "11:00pm" do
	rake 'daily_quote'
end

every :monday => "1:00am" do
	rake 'earning_report'
end
