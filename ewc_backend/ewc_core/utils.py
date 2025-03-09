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
from reportlab.lib.enums import TA_CENTER  # Import alignment constant


def calculate_percentage_change(old_value, new_value):
    '''
    Calculate the percentage change between two values.
    '''
    if old_value == 0:
        return 0
    return round(((new_value - old_value) / old_value) * 100, 2)

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

    centered_style_heading2 = ParagraphStyle(
        'CenteredStyle',
        parent=styles['Heading2'],
        alignment=TA_CENTER  # Center align the text
    )


# ========================================================================================================
# ============================================= Data Retreival ===========================================
# ========================================================================================================

       # Calculate the date one year ago from today
    today = timezone.now().date()

    one_year_ago = today - timedelta(days=365)

    # Calculate the date one month ago from today
    one_month_ago = today - timedelta(days=30)


    # Filter the data from one year ago to one month ago, excluding the last month
    year_data = RouteEnvData.objects.filter(date__gte=one_year_ago)

    month_data = RouteEnvData.objects.filter(date__gte=one_month_ago)

    month_before_data = RouteEnvData.objects.filter(date__gte=one_month_ago - timedelta(days=30), date__lt=one_month_ago)


# ========================================================================================================
# ============================================= Month Calculations =======================================
# ========================================================================================================

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

    for obj in month_data:
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



# ========================================================================================================
# ============================================= Month Before Calculations ================================
# ========================================================================================================

    # Aggregated Data Calculations
    total_distance_mb = 0
    total_fuel_consumption_mb = 0
    total_carbon_emissions_mb = 0
    total_energy_consumption_mb = 0
    total_cost_mb = 0

    for obj in month_before_data:
        distance = obj.distance
        mpg = obj.mpg

        # Calculate aggregated values
        total_distance_mb += distance
        total_fuel_consumption_mb += (distance / mpg)  # Fuel consumption = Distance / MPG
        total_carbon_emissions_mb += calculate_carbon_emissions_per_route(distance, mpg)
        total_energy_consumption_mb += calculate_energy_consumption_per_route(distance, mpg)
        total_cost_mb += calculate_cost_per_route(distance, mpg, 3.095)

    
    avg_mpg_mb = total_distance_mb / total_fuel_consumption_mb if total_fuel_consumption_mb else 0
    avg_carbon_emissions_mb = total_carbon_emissions_mb / total_distance_mb if total_distance_mb else 0
    avg_cost_per_mile_mb = total_cost_mb / total_distance_mb if total_distance_mb else 0


# ========================================================================================================
# ============================================= Year Calculations ========================================
# ========================================================================================================


    total_distance_year = 0
    total_fuel_consumption_year = 0
    total_carbon_emissions_year = 0
    total_energy_consumption_year = 0
    total_cost_year = 0

    for obj in year_data:
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
    

    # Add the aggregated data with line breaks to the PDF
    elements.append(Paragraph("Aggregated Data for the Last Month", centered_style_heading2))

    aggregated_data_table = [("Metric", "% Diff from Last Month")]
    # Data for the table: (Main Text, Percentage Change)
    aggregated_data = [
        (f"Total Distance Traveled: {total_distance:.2f} miles", f"{calculate_percentage_change(total_distance_mb, total_distance)}% change"),
        (f"Total Fuel Consumption: {total_fuel_consumption:.2f} gallons", f"{calculate_percentage_change(total_fuel_consumption_mb, total_fuel_consumption)}% change"),
        (f"Total Carbon Emissions: {total_carbon_emissions:.2f} lbs", f"{calculate_percentage_change(total_carbon_emissions_mb, total_carbon_emissions)}% change"),
        (f"Total Energy Consumption: {total_energy_consumption:.2f} gallons", f"{calculate_percentage_change(total_energy_consumption_mb, total_energy_consumption)}% change"),
        (f"Average Miles per Gallon (MPG): {avg_mpg:.2f}", f"{calculate_percentage_change(avg_mpg_mb, avg_mpg)}% change"),
        (f"Average Carbon Emissions per Mile: {avg_carbon_emissions:.2f} lbs/mile", f"{calculate_percentage_change(avg_carbon_emissions_mb, avg_carbon_emissions)}% change"),
        (f"Average Cost per Mile: {avg_cost_per_mile:.2f} dollars/mile", f"{calculate_percentage_change(avg_cost_per_mile_mb, avg_cost_per_mile)}% change")
    ]

    aggregated_data_table.extend(aggregated_data)
    # Convert data into Paragraphs to maintain styling
    aggregated_table_data = [(Paragraph(row[0], styles['BodyText']), Paragraph(row[1], styles['BodyText'])) for row in aggregated_data_table]

    # Create the table
    aggregated_table = Table(aggregated_table_data, colWidths=[300, 100])  # Adjust column widths as needed
    aggregated_table.setStyle(TableStyle([
        ('GRID', (0,0), (-1,-1), 0.5, colors.grey),  # Light grid lines
        ('ALIGN', (0,0), (0,-1), 'LEFT'),  # Align first column left
        ('ALIGN', (1,0), (-1,-1), 'RIGHT'),  # Align percentage change right
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),  # Vertical alignment to middle
        ('TEXTCOLOR', (1,0), (1,-1), colors.red),
        ('GRID', (0, 0), (-1, -1), 1, colors.white)
    ]))

    # Append the table to the elements list
    elements.append(aggregated_table)
    elements.append(Spacer(1, 20))


# ========================================================================================================
# ================================== Aggregated Data For Last Year =======================================
# ========================================================================================================

    elements.append(Paragraph("Aggregated Data for the Last Year", centered_style_heading2))

    # List of data points (each row should be a list)
    aggregated_data_year = [
        [f"Total Distance Traveled: {total_distance_year:.2f} miles"],
        [f"Total Fuel Consumption: {total_fuel_consumption_year:.2f} gallons"],
        [f"Total Carbon Emissions: {total_carbon_emissions_year:.2f} lbs"],
        [f"Total Energy Consumption: {total_energy_consumption_year:.2f} gallons"],
        [f"Average Miles per Gallon (MPG): {avg_mpg_year:.2f}"],
        [f"Average Carbon Emissions per Mile: {avg_carbon_emissions_year:.2f} lbs/mile"],
        [f"Average Cost per Mile: {avg_cost_per_mile_year:.2f} dollars/mile"]
    ]

    # Convert each row into a Paragraph for proper formatting
    aggregated_table_year_data = [[Paragraph(row[0], styles['BodyText'])] for row in aggregated_data_year]

    # Create the table with proper column width
    aggregated_table_year = Table(aggregated_table_year_data, colWidths=[400])  # Adjust width as needed
    aggregated_table_year.setStyle(TableStyle([
        ('GRID', (0,0), (-1,-1), 0.5, colors.grey),  # Light grid lines
        ('ALIGN', (0,0), (0,-1), 'LEFT'),  # Align first column left
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),  # Vertical alignment to middle
        ('TEXTCOLOR', (1,0), (1,-1), colors.red),
        ('GRID', (0, 0), (-1, -1), 1, colors.white)
    ]))

    # Add the table to the PDF
    elements.append(aggregated_table_year)
    elements.append(Spacer(1, 20))
    
# ========================================================================================================
# ================================== Charts ==============================================================
# ========================================================================================================


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
    elements.append(Paragraph("Routes Recorded in last 30 days", centered_style_heading2))

    elements.append(table)
    elements.append(Spacer(1, 30))


    # Build PDF
    doc.build(elements)
    return response
