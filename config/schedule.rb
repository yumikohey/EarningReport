set :environment, "production"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every %w( tue wed thu fri ), :at => "10:00pm" do
  rake 'daily_option_chains'
end

every %w( mon tue wed thu fri), :at => "09:30pm" do
	rake 'daily_quote'
	rake 'beta_daily_quote'
end

every %w( mon tue wed thu fri), :at => "10:30pm" do
	rake 'five_avg_daily'
end

every %w( tue wed thu fri sat), :at => "00:47am" do
	rake 'golden_cross'
end

# every :monday => "1:00am" do
# 	rake 'earning_report'
# end

# every :saturday => "2:00am" do
# 	rake 'update_db'
# end
