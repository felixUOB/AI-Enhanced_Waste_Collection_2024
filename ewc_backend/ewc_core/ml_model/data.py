import csv
from django.http import HttpResponse
from ewc_core.models import RouteEnvData

def export_stopcollection_csv (request) :
    #Create HTTP response with CSV content type
    response = HttpResponse(content_type='text/csv')
    response['Content-Disposition'] = 'attachment; filename="stopdata.csv"'
    
    #Write file
    writer = csv.writer(response)
    
    #Write header rows
    writer.writerow(["ID", "Distance", "MPG (Miles per Gallon)", "Date"])
    
    #Fill data to table in csv
    for routeenvdata in RouteEnvData.objects.all():
        writer.writerow([routeenvdata.route_env_data_id, routeenvdata.distance, routeenvdata.mpg, routeenvdata.date])
    
    return response
