from reportlab.lib.pagesizes import letter
from reportlab.pdfgen import canvas
from django.http import HttpResponse
from .models import RouteEnvData

def generate_pdf():
    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="database_table.pdf"'

    p = canvas.Canvas(response, pagesize=letter)
    width, height = letter

    p.setFont("Helvetica", 12)
    p.drawString(100, height - 50, "Database Table Report")

    y_position = height - 80  # Starting position

    data = RouteEnvData.objects.all()

    for obj in data:
        p.drawString(100, y_position, str(obj))  # Adjust formatting as needed
        y_position -= 20
        if y_position < 50:  # Prevent writing off the page
            p.showPage()
            y_position = height - 50

    p.showPage()
    p.save()
    return response
    