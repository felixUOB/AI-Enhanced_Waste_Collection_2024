# Python

# sources: https://machinelearningmastery.com/time-series-forecasting-with-prophet-in-python/

import pandas as pd
from pandas import read_csv, to_datetime
from prophet import Prophet
from prophet.plot import plot_plotly
import plotly.offline as pyo
from datetime import timedelta

# make the graph for the input
def plot_input():
    # plot a graph of the input data
    ax = df.set_index('ds').plot(figsize=(12,8))
    ax.set_ylabel('Amount of waste collected')
    ax.set_xlabel('Date')

#  load in the data
def load_data(path):
    df = read_csv(path)
    df.columns = ['Date', 'Weight Collected']

    df = df.rename(columns={'Date': 'ds', 'Weight Collected' : 'y'})
    df['ds'] = to_datetime(df['ds'])

    # sort the values by date
    df = df.sort_values(by='ds')
    return df

# plots the forecasted 
def plot(forecast):
    prediction = forecast[['ds', 'yhat', 'yhat_lower', 'yhat_upper']].tail()
    print(prediction)
    fig = plot_plotly(model, forecast)
    fig.update_layout(
        xaxis_title="Date",
        yaxis_title="Waste"
    )
    pyo.iplot(fig)

def model(path, threshold):
    # load the data
    df = load_data(path)
    
    # fit the model
    # instantiate a new Prohet object with uncertainty interval to 95%
    model = Prophet()
    model.fit(df)

    # predict next data point
    # make the prediction data frame -> provide new DataFrame that holds the dates for which we want predictions
    # generates 1 datestamps in the future

    # predict the next data point
    future_dates = model.make_future_dataframe(periods=1, freq='D') 
    forecast = model.predict(future_dates)

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

    # calculate daily waste growth
    differenceInTime = (predicatedDate - lastDate).days
    rateOfWaste_perDay = (predicatedData-lastData)/differenceInTime

    # predict the date when it will be over the threshold

    wasteTotal = lastData

    while (wasteTotal < threshold):
        wasteTotal += rateOfWaste_perDay
        lastDate += timedelta(days=1)

    collectionDate = lastDate #- timedelta(days=1)
    print("Predicted collection date: ", collectionDate)

def run_prediction_model(file_path, threshold):
    model(file_path, threshold)