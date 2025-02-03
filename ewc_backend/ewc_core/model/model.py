# Python

import pandas as pd
from prophet import Prophet
from prophet.plot import plot_plotly, plot_components_plotly
import matplotlib.pyplot as plt

# load the data
df = pd.read_csv('example.csv')
df.head()

#fit the model
m = Prophet()
m.fit(df)

# make the prediction data frame
future = m.make_future_dataframe(periods=365) # year
future.tail()

# predict a value for each row
forecast = m.predict(future)
forecast[['ds', 'yhat','yhat_lower', 'yhat_upper']].tail()

# plot the forecast
fig1 = m.plot(forecast)

fig2 = m.plot_components(forecast)

plot_plotly(m, forecast)

plot_components_plotly(m, forecast)
plt.show()