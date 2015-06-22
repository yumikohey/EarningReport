Earning Report is a web app that shows you how releases of equities' earnings affected their stock pricing. 
Even Yahoo! Finance or TD Ameritrade doesn't come with such fancy services, so I decided to build one for the public to use.

As an options trader, it's very important to know how much percentage changes after earning report released on a specific equity. It helps options traders construct the option trading strategies. 

![Home Page](https://github.com/yumikohey/EarningReport/tree/master/app/assets/images/index.jpg)
![Earning Reports](https://github.com/yumikohey/EarningReport/tree/master/app/assets/images/earning.jpg)
![Golden Cross and Death Cross Alert](https://github.com/yumikohey/EarningReport/tree/master/app/assets/images/golden_cross.jpg)
![Current Pain Chart](https://github.com/yumikohey/EarningReport/tree/master/app/assets/images/current_pain.jpg)
![Stock Portfolio](https://github.com/yumikohey/EarningReport/tree/master/app/assets/images/portfolio.jpg)

# Updates
- Current Pain <a href="options-er.herokuapp.com/current_pain">options-er.herokuapp.com/current_pain</a> is up. Current Pain is trying to predict what price an equity is going to land at the end of the trading day.
- Web application has a fresh outlook now.
- Five Days and Ten Days Simple Moving Average Golden / Death Cross Alert feature is up. 
  * Golden Cross indicates that a stock reverts from downward trend to upward trend.
  * Death Cross indicates that a stock ends its upward trend and enters into downward trend.
  * We sort the alert list based on an equity's options Open Interests.
- Historical data since 2010.


# Stretch Goals

- Based on historical data, providing optimal options trading strategies;
- TD Sequential Counter Alert;
- When you search an equity's upcoming earning report dates, we will show you its competitors earning report results.


