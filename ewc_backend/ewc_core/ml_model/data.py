import csv
import os
import io
from django.conf import settings
from django.http import HttpResponse
from ewc_core.models import RouteEnvData
from ewc_core.models import StopCollection
from ewc_core.models import UserProfile

def generate_csv(filename, headers, queryset, data_extractor):
    # Define the directory path
    dir_path = os.path.join(settings.BASE_DIR, "ewc_core", "ml_model")

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
    

def export_routeenvdata_csv (request) :
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
    return HttpResponse(f"CSV file saved at: {file_path}")

def export_stopdata_csv (request) :
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
    return HttpResponse(f"CSV file saved at: {file_path}")

def export_userdata_csv (request) :
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
    return HttpResponse(f"CSV file saved at: {file_path}")
