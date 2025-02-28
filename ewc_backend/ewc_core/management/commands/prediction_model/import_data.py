import csv
import os
import io
from django.conf import settings
from django.http import HttpResponse
from ewc_core.models import RouteEnvData, UserProfile, Stops
from ewc_core.models import StopCollection

# this file imports the data from the database and saves them as csv files

# file for generating a csv
def generate_csv(filename, headers, queryset, data_extractor):
    # Define the directory path
    dir_path = os.path.join(settings.BASE_DIR, "ewc_core", "management/commands/prediction_model/data")

    # Ensure the directory exists
    os.makedirs(dir_path, exist_ok=True)

    # Define full file path
    file_path = os.path.join(dir_path, filename)

    # Write CSV file to the directory
    with open(file_path, mode="w", newline="", encoding="utf-8") as file:
        writer = csv.writer(file)
        
        # Write headers
        writer.writerow(headers)
        
        # Write data rows
        for query in queryset:
            writer.writerow(data_extractor(query))

    return file_path 
    
# #importing route environment data
def export_routeenvdata_csv () :
    try:
        file_path = generate_csv(
            filename="routeenvdata.csv",
            headers=["Date","Distance","MPG"],
            queryset=RouteEnvData.objects.all(),
            data_extractor=lambda routeenvdata :
                [
                    routeenvdata.date.strftime("%Y-%m-%d"),
                    routeenvdata.distance,
                    routeenvdata.mpg
                ] 
        )
        return file_path
    except Exception as e:
        print(f"Error exporting Route Environment Data {e}")
        return None

#Exporting stop collection data
def export_stopdata_csv(stopid) :
    try:
        file_path = generate_csv(
            filename="stopdata.csv",
            headers=["Date","Weight Collected"],
            queryset=StopCollection.objects.all().filter(stop_id = stopid),
            data_extractor=lambda stopdata :
                [
                    stopdata.date,
                    stopdata.weight_collected
                ] 
        )
        return file_path
    except Exception as e:
        print(f"Error exporting Stop Data {e}")
        return None


#Exporting user data
def export_userdata_csv (request) :
    try:
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
    except Exception as e:
        print(f"Error exporting User Profile Data {e}")
        return None
    
# get the maximum amount of weight that can be stored at each stop
def get_threshold(stopid):
    query = Stops.objects.get(stop_id=3)
    max_weight = query.max_weight
    return max_weight

def generate_data(stopid):
    return export_stopdata_csv(3)
    