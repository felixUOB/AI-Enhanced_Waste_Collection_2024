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
from reportlab.platypus import PageBreak


def calculate_carbon_emissions_per_route(distance, mpg):
    '''
    Calculate carbon emissions based on distance and fuel efficiency.
    '''
    carbon_emissions = distance / mpg * 19.6  # 19.6 lbs of CO2 per gallon of gasoline
    return carbon_emissions

def calculate_energy_consumption_per_route(distance, mpg):
    '''
    Calculate energy consumption based on distance and fuel efficiency.
    '''
    energy_consumption = distance / mpg
    return energy_consumption

def calculate_cost_per_route(distance, mpg, cost_per_gallon):
    '''
    Calculate cost based on distance, fuel efficiency, and cost per gallon.
    '''
    cost = distance / mpg * cost_per_gallon
    return cost


def generate_pdf():
    '''
    Generate a PDF report based on environmental impact data.
    '''

    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="environmental_impact_report.pdf"'

    doc = SimpleDocTemplate(response, pagesize=letter, topMargin=20, bottomMargin=20, leftMargin=45, rightMargin=45)
    elements = []
    styles = getSampleStyleSheet()


# ========================================================================================================
# ============================================= Icon =====================================================
# ========================================================================================================

    icon_path = "static/images/RecycleNXT-Logo_Update_Black.png" 
    aspect_ratio = 2.7
    height = 80
    width = height * aspect_ratio
    icon = Image(icon_path, width=width, height=height)

    elements.append(icon)
    elements.append(Spacer(1, 20))


# ========================================================================================================
# =========================================== Title ======================================================
# ========================================================================================================
    
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
    elements.append(Spacer(1, 10))


# ========================================================================================================
# ================================== Aggregated Data For Last Month ======================================
# ========================================================================================================


    # Filter data where the date is within the last month
    one_month_ago = timezone.now().date() - timedelta(days=30)
    data = RouteEnvData.objects.filter(date__gte=one_month_ago)

    # Extract field names (table headers)
    field_names = [field.verbose_name if field.verbose_name else field.name for field in RouteEnvData._meta.fields]

    # Prepare table data (headers + records)
    table_data = [field_names]  # Add headers as the first row

    # Aggregated Data Calculations
    total_distance = 0
    total_fuel_consumption = 0
    total_carbon_emissions = 0
    total_energy_consumption = 0
    total_cost = 0

    for obj in data:
        row = [str(getattr(obj, field.name)) for field in RouteEnvData._meta.fields]
        table_data.append(row)

        distance = obj.distance
        mpg = obj.mpg

        # Calculate aggregated values
        total_distance += distance
        total_fuel_consumption += (distance / mpg)  # Fuel consumption = Distance / MPG
        total_carbon_emissions += calculate_carbon_emissions_per_route(distance, mpg)
        total_energy_consumption += calculate_energy_consumption_per_route(distance, mpg)
        total_cost += calculate_cost_per_route(distance, mpg, 3.095)

    
    avg_mpg = total_distance / total_fuel_consumption if total_fuel_consumption else 0
    avg_carbon_emissions = total_carbon_emissions / total_distance if total_distance else 0
    avg_cost_per_mile = total_cost / total_distance if total_distance else 0

    aggregated_data = f"""
    Total Distance Traveled: {total_distance:.2f} miles<br />
    Total Fuel Consumption: {total_fuel_consumption:.2f} gallons<br />
    Total Carbon Emissions: {total_carbon_emissions:.2f} lbs<br />
    Total Energy Consumption: {total_energy_consumption:.2f} gallons<br />
    Average Miles per Gallon (MPG): {avg_mpg:.2f}<br />
    Average Carbon Emissions per Mile: {avg_carbon_emissions:.2f} lbs/mile<br />
    Average Cost per Mile: {avg_cost_per_mile:.2f} dollars/mile<br />
    """

    # Add the aggregated data with line breaks to the PDF
    elements.append(Paragraph("Aggregated Data for the Last Year (Exclusive)", styles['Heading2']))
    elements.append(Paragraph(aggregated_data, styles['BodyText']))
    elements.append(Spacer(1, 20))


# ========================================================================================================
# ================================== Aggregated Data For Last Year =======================================
# ========================================================================================================


    # Calculate the date one year ago from today
    today = timezone.now().date()

    one_year_ago = today - timedelta(days=365)

    # Calculate the date one month ago from today
    one_month_ago = today - timedelta(days=30)

    # Filter the data from one year ago to one month ago, excluding the last month
    data_last_year_excluding_last_month = RouteEnvData.objects.filter(date__gte=one_year_ago, date__lt=one_month_ago)

    total_distance_year = 0
    total_fuel_consumption_year = 0
    total_carbon_emissions_year = 0
    total_energy_consumption_year = 0
    total_cost_year = 0

    for obj in data_last_year_excluding_last_month:
        distance = obj.distance
        mpg = obj.mpg

        # Calculate aggregated values
        total_distance_year += distance
        total_fuel_consumption_year += (distance / mpg)  # Fuel consumption = Distance / MPG
        total_carbon_emissions_year += calculate_carbon_emissions_per_route(distance, mpg)
        total_energy_consumption_year += calculate_energy_consumption_per_route(distance, mpg)
        total_cost_year += calculate_cost_per_route(distance, mpg, 3.095)

    
    avg_mpg_year = total_distance_year / total_fuel_consumption_year if total_fuel_consumption_year else 0
    avg_carbon_emissions_year = total_carbon_emissions_year / total_distance_year if total_distance_year else 0
    avg_cost_per_mile_year = total_cost_year / total_distance_year if total_distance_year else 0

    aggregated_data_year = f"""
    Total Distance Traveled: {total_distance_year:.2f} miles<br />
    Total Fuel Consumption: {total_fuel_consumption_year:.2f} gallons<br />
    Total Carbon Emissions: {total_carbon_emissions_year:.2f} lbs<br />
    Total Energy Consumption: {total_energy_consumption_year:.2f} gallons<br />
    Average Miles per Gallon (MPG): {avg_mpg_year:.2f}<br />
    Average Carbon Emissions per Mile: {avg_carbon_emissions_year:.2f} lbs/mile<br />
    Average Cost per Mile: {avg_cost_per_mile_year:.2f} dollars/mile<br />
    """

    # Add the aggregated data with line breaks to the PDF
    elements.append(Paragraph("Aggregated Data for the Last Month", styles['Heading2']))
    elements.append(Paragraph(aggregated_data_year, styles['BodyText']))
    elements.append(Spacer(1, 20))

# ========================================================================================================
# ================================== Charts ==============================================================
# ========================================================================================================


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


    # Make table stretch across the page
    page_width, _ = letter
    col_widths = [(page_width - 100) / len(field_names)] * len(field_names)  # Distribute width equally

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

    
    elements.append(PageBreak())
    elements.append(table)
    elements.append(Spacer(1, 30))


    # Conclusion
    conclusion_text = """The data indicates that Region B has the highest carbon emissions and energy consumption. 
    Further investigation is recommended to explore sustainable practices in this region."""
    elements.append(Paragraph(conclusion_text, styles['BodyText']))

    # Build PDF
    doc.build(elements)
    return response
