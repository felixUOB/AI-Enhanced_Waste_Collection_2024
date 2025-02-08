# Python

# sources: https://machinelearningmastery.com/time-series-forecasting-with-prophet-in-python/

import pandas as pd
from pandas import read_csv, to_datetime
import numpy as np
from prophet import Prophet
from prophet.plot import plot_plotly, plot_components_plotly, add_changepoints_to_plot
import matplotlib.pyplot as plt
import plotly.offline as pyo
from datetime import date, timedelta

# threshold value
threshold = 8 # get this value out of the database for each of the stops

# load the data -> from the database
# df = pd.read_csv('https://raw.githubusercontent.com/facebook/prophet/main/examples/example_wp_log_peyton_manning.csv')
df = read_csv('example.csv')
df.columns = ['ds', 'y']
df['ds'] = to_datetime(df['ds'])

# plot a graph of the input data
ax = df.set_index('ds').plot(figsize=(12,8))
ax.set_ylabel('Amount of waste collected')
ax.set_xlabel('Date')
# plot the graph
# plt.show(block=False)


# instantiate a new Prohet object with uncertainty interval to 95%
model = Prophet()
# fit the model
model.fit(df)

# make the prediction data frame -> provide new DataFrame that holds the dates for which we want predictions
# generates 36 datestamps in the future
# state the frequency of the data
future_dates = model.make_future_dataframe(periods=1, freq='ME') 
future_dates.head()

forecast = model.predict(future_dates)
prediction = forecast[['ds', 'yhat', 'yhat_lower', 'yhat_upper']].tail()

fig = plot_plotly(model, forecast)
fig.update_layout(
    xaxis_title="Date",
    yaxis_title="Waste"
)

# pyo.iplot(fig)

# workout the monthely growth rate for the coming no
# workout the amount of waste that is expected to be produced per day
# from that work out when the waste needs to be collected

# work out the time betweent the two points

predictedValue = forecast.tail(1) # the predicted value
lastValue = df.tail(1) # the last actual data

predicatedDate =pd.to_datetime(predictedValue['ds'].iloc[0])
lastDate = pd.to_datetime(lastValue['ds'].iloc[0])

predicatedData = float(predictedValue['yhat'].iloc[0])
lastData = float(lastValue['y'].iloc[0])
differenceInTime = (predicatedDate - lastDate).days
# rate of change
rateOfWaste_perDay = predicatedData/differenceInTime

# predict the date when it will be over the threshold

wasteTotal = 0

while (wasteTotal < threshold):
    wasteTotal = rateOfWaste_perDay + wasteTotal
    lastDate = lastDate + timedelta(days=1)

collectionDate = lastDate - timedelta(days=1)
print(collectionDate)