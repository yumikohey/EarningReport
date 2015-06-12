desc 'download yahoo finance option chains'
task daily_option_chains: :environment do
	DailyOptionHelper.option_chains
end

desc 'testing'
task testing: :environment do
        OptionChain.create!(symbol:'XXX')
        p "im here"
end
