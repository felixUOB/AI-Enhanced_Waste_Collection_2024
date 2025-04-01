# Python

# sources: https://machinelearningmastery.com/time-series-forecasting-with-prophet-in-python/

from matplotlib import pyplot as plt
import pandas as pd
from pandas import read_csv, to_datetime
from prophet import Prophet
from prophet.plot import plot_plotly
import plotly.offline as pyo
from datetime import datetime, timedelta

# make the graph for the input
def plot_input(df):
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
def plot(model, forecast):
    # prediction = forecast[['ds', 'yhat', 'yhat_lower', 'yhat_upper']].tail()
    # print(prediction)
    # fig = plot_plotly(model, forecast)
    # fig.update_layout(
    #     xaxis_title="Date",
    #     yaxis_title="Waste"
    # )
    # pyo.iplot(fig)
    fig = model.plot(forecast)
    plt.show()
    
# fill in the missing days with the accumulating growth i.e. interpolate the daily waste weight
def fillInDates(df): 
    # store the list of accumulated weights
    filled_data=[]
    # get the weight at the first collection
    current_weight = float(df['y'].iloc[0])
    # get the data the the first collection occurred
    last_collection_day = pd.to_datetime(df['ds'].iloc[0])
    
    # append the first line of the data
    filled_data.append({"ds": last_collection_day, "y": current_weight})
    current_weight = 0
    # loop through each of the old dates and fill in the gaps
    for i in range(1, len(df)):  
        current_day = df["ds"].iloc[i]
        collected_weight = df["y"].iloc[i]

        # Calculate accumulation rate (waste growth per day)
        days_between = (current_day - last_collection_day).days
        if days_between > 0:
            daily_growth = collected_weight / days_between  # Assuming even distribution

            # Fill in missing days
            for j in range(1, days_between):
                new_day = last_collection_day + timedelta(days=j)
                current_weight += daily_growth
                filled_data.append({"ds": new_day, "y": current_weight})

        # Add the actual collection day and reset accumulation
        filled_data.append({"ds": current_day, "y": collected_weight})
        last_collection_day = current_day
        current_weight = 0  # Reset after collection
    # Convert list to DataFrame
    return pd.DataFrame(filled_data)

def train_model(df):
    # fit the model
    # instantiate a new Prophet object with uncertainty interval to 95%
    model = Prophet()
    model.fit(df)
     # predict the next data point
    future_dates = model.make_future_dataframe(periods=30, freq='D') 

    # predict next data point
    # make the prediction data frame -> provide new DataFrame that holds the dates for which we want predictions
    # generates 30 days in the future

    forecast = model.predict(future_dates)

    return model, forecast


def main(path, threshold):
    # load the data
    df = load_data(path)
    if (len(df) > 1):
    # add in the middle days to make it accumulating data
        df_complete = fillInDates(df)

        # train the model
        model, forecast = train_model(df_complete)

        # find the max value before it starts to fall
        counter = len(df_complete) +1
        while (forecast["yhat"].iloc[counter] < forecast["yhat"].iloc[counter + 1] and forecast["yhat"].iloc[counter] < threshold and counter < len(forecast) + 30 -1):
            counter += 1

        return forecast["ds"].iloc[counter]
    else:
        return datetime.now() + timedelta(days=7)


def run_prediction_model(file_path, threshold):
    return main(file_path, threshold)