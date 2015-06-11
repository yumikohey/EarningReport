desc 'download yahoo finance option chains'
task daily_option_chains: :environment do
	DailyOptionHelper.option_chains
end
