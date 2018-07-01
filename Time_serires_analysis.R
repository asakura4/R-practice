kings <- scan("http://robjhyndman.com/tsdldata/misc/kings.dat",skip=3)

#store data in time series object
kingstimeseires <- ts(kings, start = 1)
kingstimeseires

# you can specify the number of times that data was collected per 
# year by using the ¡¥frequency¡¦ parameter in the ts() function. 
# For monthly time series data, you set frequency=12, while 
# for quarterly time series data, you set frequency=4.

# example 1.
births <- scan("http://robjhyndman.com/tsdldata/data/nybirths.dat")
birthstimeseries <- ts(births, frequency=12, start=c(1946,1))
birthstimeseries

# example 2.
souvenir <- scan("http://robjhyndman.com/tsdldata/data/fancy.dat")
souvenirtimeseries <- ts(souvenir, frequency=12, start=c(1987,1))
souvenirtimeseries

# plot time series
plot.ts(kingstimeseries)
plot.ts(birthstimeseries)

plot.ts(souvenirtimeseries)
logsouvenirtimeseries <- log(souvenirtimeseries)
plot.ts(logsouvenirtimeseries)

# =======================================

# Decomposing Non-Seasonal Data
library("TTR")
# Smoothing Method SMA()

# smooth the time series using a simple moving average of order 3, 
# and plot the smoothed time series data, we type
kingstimeseriesSMA3 <- SMA(kingstimeseries,n=3)
plot.ts(kingstimeseriesSMA3)
kingstimeseriesSMA8 <- SMA(kingstimeseries,n=8)
plot.ts(kingstimeseriesSMA8)

# Decomposing Seasonal Data
birthstimeseriescomponents <- decompose(birthstimeseries)
birthstimeseriescomponents$seasonal
plot(birthstimeseriescomponents)

# Seasonally Adjusting

# For example, to seasonally adjust the time series of the number of births per 
# month in New York city, we can estimate the seasonal component using 
# ¡§decompose()¡¨, and then subtract the seasonal component from the original 
# time series:

birthstimeseriescomponents <- decompose(birthstimeseries)
birthstimeseriesseasonallyadjusted <- birthstimeseries - birthstimeseriescomponents$seasonal

plot(birthstimeseriesseasonallyadjusted)

# ===============================================

# Forecasts using Exponential Smoothing

# Simple Exponentioal Smoothing
rain <- scan("http://robjhyndman.com/tsdldata/hurst/precip1.dat",skip=1)
rainseries <- ts(rain,start=c(1813))
plot.ts(rainseries)
rainseriesforecasts <- HoltWinters(rainseries, beta=FALSE, gamma=FALSE)
rainseriesforecasts
rainseriesforecasts$fitted

library("forecast")
m <- HoltWinters(rainseries, beta=FALSE, gamma=FALSE)
rainseriesforecasts2<-forecast(m)
rainseriesforecasts2
plot(rainseriesforecasts2)

res <- rainseriesforecasts2$residuals[!is.na(rainseriesforecasts2$residuals)]

acf(res , lag.max=20)
Box.test(res, lag=20, type="Ljung-Box")

plot.ts(res)
