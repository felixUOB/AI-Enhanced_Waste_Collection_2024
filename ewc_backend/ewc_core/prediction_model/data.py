import csv
import os
import io
from django.conf import settings
from django.http import HttpResponse
from ewc_core.models import RouteEnvData
from ewc_core.models import StopCollection


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
    
# #Exporting route environment data
def export_routeenvdata_csv () :
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
    return HttpResponse(f"CSV file saved at: {file_path}")


#Exporting stop collection data
def export_stopdata_csv() :
    file_path = generate_csv(
        filename="stopdata.csv",
        headers=["Date","Weight Collected"],
        queryset=StopCollection.objects.all(),
        data_extractor=lambda stopdata :
            [
                stopdata.date,
                stopdata.weight_collected
            ] 
    )
    return HttpResponse(f"CSV file saved at: {file_path}")

export_stopdata_csv()

# #Exporting user data
# def export_userdata_csv (request) :
#     file_path = generate_csv(
#         filename="userdata.csv",
#         headers=["Pickup frequency","Waste Preferences","Carbon Savings"],
#         queryset=UserProfile.objects.all(),
#         data_extractor=lambda userdata :
#             [
#                 userdata.pickup_frequency,
#                 userdata.waste_type_preference,
#                 userdata.carbon_savings
#             ] 
#     )
#     return HttpResponse(f"CSV file saved at: {file_path}")
