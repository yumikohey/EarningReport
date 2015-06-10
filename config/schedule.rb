# every :day, :at => '3:25 pm' do

set :environment, "development"
set :output, {:error => "log/cron_error_log.log", :standard => "log/cron_log.log"}

every :day, :at => "7am" do
  rake 'daily_option_chains'
end
