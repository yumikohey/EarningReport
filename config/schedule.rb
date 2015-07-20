set :environment, "production"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every %w( mon tue wed thu ), :at => "11:30pm" do
  rake 'daily_option_chains'
end


every %w( mon tue wed thu fri), :at => "9:40pm" do
	rake 'daily_quote'
	rake 'beta_daily_quote'
end


every %w( mon tue wed thu fri), :at => "10:30pm" do
	rake 'five_avg_daily'
end


every %w( mon tue wed thu fri), :at => "11:30pm" do
	rake 'golden_cross'
end


