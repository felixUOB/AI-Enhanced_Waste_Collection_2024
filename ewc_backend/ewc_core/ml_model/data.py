import csv
import os
from django.conf import settings
from django.http import HttpResponse
from ewc_core.models import RouteEnvData

def export_routeenvdata_csv (request) :
    #Define file path
    dir = os.path.abspath(os.path.join(settings.BASE_DIR, "ewc_core","ml_model"))
    
    #Ensure directory exists
    os.makedirs(dir, exist_ok=True)
    
    path = os.path.join(dir, "routeenvdata.csv")
    # #Create HTTP response with CSV content type
    # response = HttpResponse(content_type='text/csv')
    
    
    with open(path, mode="w", newline="", encoding='utf-8') as file :
    
        #Write file
        writer = csv.writer(file)
    
        #Write header rows
        writer.writerow(["ID", "Distance", "MPG (Miles per Gallon)", "Date"])
        
        #Fill data to table in csv
        for routeenvdata in RouteEnvData.objects.all():
            writer.writerow([
                routeenvdata.route_env_data_id, 
                routeenvdata.distance, 
                routeenvdata.mpg, 
                routeenvdata.date.strftime("%Y-%m-%d")
                ])
        
    with open(path, "rb") as file :
        response = HttpResponse(file.read(), content_type="text/csv")
        response['Content-Disposition'] = f'attachment; filename="routeenvdata.csv"'
        
    return response
