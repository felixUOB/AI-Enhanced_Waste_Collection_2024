# Python

import pandas as pd
from prophet import Prophet
from prophet.plot import plot_plotly, plot_components_plotly
import matplotlib.pyplot as plt

# threshold value
threshold = 8

# load the data
df = pd.read_csv('https://raw.githubusercontent.com/facebook/prophet/main/examples/example_wp_log_peyton_manning.csv')
df.head()

#fit the model
m = Prophet()
m.fit(df)

# make the prediction data frame
future = m.make_future_dataframe(periods=365) # year
future.tail()

# predict a value for each row
forecast = m.predict(future)
# yhat is the predicted value
forecast[['ds', 'yhat','yhat_lower', 'yhat_upper']].tail()

# plot the forecast
# fig1 = m.plot(forecast)

# fig2 = m.plot_components(forecast)

# plot_plotly(m, forecast)

# plot_components_plotly(m, forecast)
# plt.show()

# idea:
# predict the amount of waste that will be at each stop 
# when it passes a threshold then it should be picked up

# loop through the dates and the data
for i in range(0, len(forecast.ds)):
    date = forecast.ds[i]
    data = forecast.yhat[i]
    if (data > threshold):
        print("pick up")
    