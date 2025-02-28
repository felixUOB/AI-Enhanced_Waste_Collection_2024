# Python
import csv
import os
from django.conf import settings
from ewc_core.models import RouteEnvData
from ewc_core.models import StopCollection
from ewc_core.models import UserProfile
from django.http import HttpResponse
# from ewc_core.prediction_model.data import generate_csv

#csv files creation
def generate_csv(filename, headers, queryset, data_extractor):
    # Define the directory path
    dir_path = os.path.join(settings.BASE_DIR, "ewc_core", "prediction_model")

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

#Exporting route environment data
def export_routeenvdata_csv () :
    route_queryset = RouteEnvData.objects.all()
    
    #check if file is empty
    if not route_queryset.exists() :
        print("No Route Environment Data Found, no files generated")
        return None
    
    #File Generation
    try :
        file_path = generate_csv(
            filename="routeenvdata.csv",
            headers=["Date","Distance","MPG (Miles Per Gallon)"],
            queryset=route_queryset,
            data_extractor=lambda routeenvdata :
                [
                    routeenvdata.date.strftime("%Y-%m-%d"),
                    routeenvdata.distance,
                    routeenvdata.mpg,
                ] 
        )
        return file_path
    except Exception as e :
        print(f"Error exporting Route Environment Data {e}")
        return None

#Exporting stop collection data
def export_stopdata_csv () :
    stop_queryset = StopCollection.objects.all()
    
    #check if file is empty
    if not stop_queryset.exists() :
        print("No Stop Collection Data Found, no files generated")
        return None
    
    #File Generation
    try :
        file_path = generate_csv(
            filename="stopdata.csv",
            headers=["Weight Collected", "Date collected"],
            queryset=stop_queryset,
            data_extractor=lambda stopdata :
                [
                    stopdata.weight_collected,
                    stopdata.date,
                ] 
        )
        return file_path
    except Exception as e :
        print(f"Error exporting Stop Collection Data {e}")
        return None

#Exporting user data
def export_userdata_csv () :
    
    user_queryset = UserProfile.objects.all()
    
    #check if file is empty
    if not user_queryset.exists() :
        print("No User Profile Data Found, no files generated")
        return None
    
    #File Generation
    try :
        file_path = generate_csv(
            filename="userdata.csv",
            headers=["Pickup frequency","Waste Preferences","Carbon Savings"],
            queryset=user_queryset,
            data_extractor=lambda userdata :
                [
                    userdata.pickup_frequency,
                    userdata.waste_type_preference,
                    userdata.carbon_savings
                ] 
        )
        return file_path
    except Exception as e :
        print(f"Error exporting User Profile Data {e}")
        return None
    
def generate_csv_files(request) :
    print("Generating CSV files...")
    route_csv = export_routeenvdata_csv()
    stop_csv = export_stopdata_csv()
    user_csv = export_userdata_csv()
    print("Files Generated!!")
    return HttpResponse("DONE")

export_stopdata_csv()