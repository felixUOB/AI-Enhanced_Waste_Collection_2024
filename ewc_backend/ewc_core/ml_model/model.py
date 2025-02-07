# Python

import pandas as pd
from prophet import Prophet
from prophet.plot import plot_plotly, plot_components_plotly
import matplotlib.pyplot as plt
from ewc_core.models import RouteEnvData
from ewc_core.models import StopCollection
from ewc_core.models import UserProfile
from django.http import HttpResponse
from ewc_core.ml_model.data import generate_csv

#csv files creation

#Exporting route environment data
def export_routeenvdata_csv () :
    file_path = generate_csv(
        filename="routeenvdata.csv",
        headers=["Date","Distance","MPG (Miles Per Gallon)"],
        queryset=RouteEnvData.objects.all(),
        data_extractor=lambda routeenvdata :
            [
                routeenvdata.date.strftime("%Y-%m-%d"),
                routeenvdata.distance,
                routeenvdata.mpg
            ] 
    )
    return file_path

#Exporting stop collection data
def export_stopdata_csv () :
    file_path = generate_csv(
        filename="stopdata.csv",
        headers=["Stop ID","Weight Collected"],
        queryset=StopCollection.objects.all(),
        data_extractor=lambda stopdata :
            [
                stopdata.stop_collection_id,
                stopdata.weight_collected
                
            ] 
    )
    return file_path

#Exporting user data
def export_userdata_csv () :
    file_path = generate_csv(
        filename="userdata.csv",
        headers=["Pickup frequency","Waste Preferences","Carbon Savings"],
        queryset=UserProfile.objects.all(),
        data_extractor=lambda userdata :
            [
                userdata.pickup_frequency,
                userdata.waste_type_preference,
                userdata.carbon_savings
            ] 
    )
    return file_path

def getdata(request) :
    print("Generating CSV files...")
    route_csv = export_routeenvdata_csv()
    stop_csv = export_stopdata_csv()
    user_csv = export_userdata_csv()
    print("Files Generated!!")
    return HttpResponse("DONE")

# model starts here

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
    