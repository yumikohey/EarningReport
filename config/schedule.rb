set :environment, "production"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every %w( tue wed thu fri ), :at => "5:00am" do
  rake 'daily_option_chains'
end

every %w( tue wed thu fri sat) => "1:00am" do
	rake 'daily_quote'
	rake 'beta_daily_quote'
	rake 'five_avg_daily'
	rake 'golden_cross'
end

every %w( tue wed thu fri sat) => "3:00am" do
	rake 'five_avg_daily'
	rake 'golden_cross'
end

every :tuesday => "4:00am" do
	rake 'earning_report'
end

# every :saturday => "2:00am" do
# 	rake 'update_db'
# end
