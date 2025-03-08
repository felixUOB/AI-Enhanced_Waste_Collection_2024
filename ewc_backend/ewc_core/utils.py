from django.http import HttpResponse
from django.utils import timezone
from datetime import timedelta
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.graphics.shapes import Drawing
from reportlab.graphics.charts.barcharts import VerticalBarChart
from reportlab.graphics.charts.textlabels import Label
from .models import RouteEnvData
from reportlab.platypus import Image

def generate_pdf():
    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="environmental_impact_report.pdf"'

    doc = SimpleDocTemplate(response, pagesize=letter)
    elements = []
    styles = getSampleStyleSheet()


    icon_path = "static/images/RecycleNXT-Logo_Update_Black.png" 
    aspect_ratio = 2.7
    height = 80
    width = height * aspect_ratio
    icon = Image(icon_path, width=width, height=height)

    elements.append(icon)
    elements.append(Spacer(1, 20))
    
    # Custom Title Style
    title_style = ParagraphStyle(
        'TitleStyle',
        parent=styles['Title'],
        fontSize=20,
        textColor=colors.darkgreen,
        spaceAfter=20,
        alignment=1  # Center align
    )

    # Title Page
    elements.append(Paragraph("Environmental Impact Report", title_style))
    elements.append(Spacer(1, 20))

    # Executive Summary
    summary_text = """This report presents the environmental impact analysis based on recent data collection. 
    The focus is on carbon emissions over the last month."""
    elements.append(Paragraph(summary_text, styles['BodyText']))
    elements.append(Spacer(1, 20))

    # Filter data where the date is within the last month
    one_month_ago = timezone.now().date() - timedelta(days=30)
    data = RouteEnvData.objects.filter(date__gte=one_month_ago)

    # Extract field names (table headers)
    field_names = [field.verbose_name if field.verbose_name else field.name for field in RouteEnvData._meta.fields]

    # Prepare table data (headers + records)
    table_data = [field_names]  # Add headers as the first row
    for obj in data:
        row = [str(getattr(obj, field.name)) for field in RouteEnvData._meta.fields]
        table_data.append(row)

    # Make table stretch across the page
    page_width, _ = letter
    col_widths = [(page_width - 50) / len(field_names)] * len(field_names)  # Distribute width equally

    # Create and style the table
    table = Table(table_data, colWidths=col_widths)
    table.setStyle(TableStyle([
        ('BACKGROUND', (0, 0), (-1, 0), colors.darkgreen),
        ('TEXTCOLOR', (0, 0), (-1, 0), colors.whitesmoke),
        ('ALIGN', (0, 0), (-1, -1), 'CENTER'),
        ('FONTNAME', (0, 0), (-1, 0), 'Helvetica-Bold'),
        ('FONTSIZE', (0, 0), (-1, 0), 12),
        ('BOTTOMPADDING', (0, 0), (-1, 0), 8),
        ('GRID', (0, 0), (-1, -1), 1, colors.black)
    ]))

    elements.append(table)
    elements.append(Spacer(1, 30))

    # Bar Chart for Carbon Emissions
    drawing = Drawing(450, 250)
    bar_chart = VerticalBarChart()
    bar_chart.x = 50
    bar_chart.y = 50
    bar_chart.height = 150
    bar_chart.width = 350
    bar_chart.data = [[120, 140, 110]]  # Example Carbon Emissions Data
    bar_chart.categoryAxis.categoryNames = ["Region A", "Region B", "Region C"]
    bar_chart.bars[0].fillColor = colors.blue

    # Add title to chart
    chart_label = Label()
    chart_label.setOrigin(225, 220)  # Center title
    chart_label.setText("Carbon Emissions (tons)")
    chart_label.fontSize = 14
    drawing.add(chart_label)

    drawing.add(bar_chart)
    elements.append(drawing)
    elements.append(Spacer(1, 30))

    # Conclusion
    conclusion_text = """The data indicates that Region B has the highest carbon emissions and energy consumption. 
    Further investigation is recommended to explore sustainable practices in this region."""
    elements.append(Paragraph(conclusion_text, styles['BodyText']))

    # Build PDF
    doc.build(elements)
    return response
