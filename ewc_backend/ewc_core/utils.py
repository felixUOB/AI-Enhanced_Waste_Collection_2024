from django.http import HttpResponse
from django.utils import timezone
from datetime import datetime, timedelta
from reportlab.lib.pagesizes import letter
from reportlab.platypus import SimpleDocTemplate, Table, TableStyle, Paragraph, Spacer
from reportlab.lib import colors
from reportlab.lib.styles import getSampleStyleSheet, ParagraphStyle
from reportlab.graphics.shapes import Drawing, String
from .models import RouteEnvData
from reportlab.platypus import Image, PageBreak
from reportlab.lib.enums import TA_CENTER
from reportlab.graphics.charts.lineplots import LinePlot
from reportlab.graphics.charts.axes import XValueAxis, YValueAxis
from reportlab.graphics.widgets.markers import makeMarker

def create_line_chart(db_data):
    '''
    Creates a line chart representing carbon emissions over the last six months.
    '''
    drawing = Drawing(400, 180)  # Increased height to fit labels

    # Map months to numeric positions (0 to 5)
    months = get_last_6_months()
    x_positions = list(range(6))  # 0, 1, 2, 3, 4, 5

    # Initialize data for each month
    month_0_data = 0
    month_1_data = 0
    month_2_data = 0
    month_3_data = 0
    month_4_data = 0
    month_5_data = 0

    # Calculate carbon emissions for each month    
    for obj in db_data:
        if obj.date.strftime("%b %Y") == months[0]:
            month_0_data += calculate_carbon_emissions_per_route(obj.distance, obj.mpg)
        elif obj.date.strftime("%b %Y") == months[1]:
            month_1_data += calculate_carbon_emissions_per_route(obj.distance, obj.mpg)
        elif obj.date.strftime("%b %Y") == months[2]:
            month_2_data += calculate_carbon_emissions_per_route(obj.distance, obj.mpg)
        elif obj.date.strftime("%b %Y") == months[3]:
            month_3_data += calculate_carbon_emissions_per_route(obj.distance, obj.mpg)
        elif obj.date.strftime("%b %Y") == months[4]:
            month_4_data += calculate_carbon_emissions_per_route(obj.distance, obj.mpg)
        elif obj.date.strftime("%b %Y") == months[5]:
            month_5_data += calculate_carbon_emissions_per_route(obj.distance, obj.mpg)

    # Define Data (Using x_positions instead of month names)
    data = [
        [(x_positions[i], y) for i, y in enumerate([month_0_data, month_1_data, month_2_data, month_3_data, month_4_data, month_5_data])],
    ]

    # Create Line Plot
    lp = LinePlot()
    lp.x = 50
    lp.y = 50
    lp.height = 125
    lp.width = 400
    lp.data = data
    lp.joinedLines = 1
    lp.strokeColor = colors.black

    # Style the lines
    lp.lines[0].strokeColor = colors.red
    lp.lines[0].symbol = makeMarker('FilledCircle')
    lp.lines[1].strokeColor = colors.blue
    lp.lines[1].symbol = makeMarker('FilledDiamond')

    # Configure X-Axis (using numerical indices)
    lp.xValueAxis = XValueAxis()
    lp.xValueAxis.valueMin = 0
    lp.xValueAxis.valueMax = 5
    lp.xValueAxis.valueStep = 1
    lp.xValueAxis.labels.visible = False
    lp.xValueAxis.visibleGrid = 1
    x_axis_label = String(225, 10, "Time Period", fontSize=10, fillColor=colors.black)
    drawing.add(x_axis_label)  # Add label to the drawing

    # Configure Y-Axis
    lp.yValueAxis = YValueAxis()
    lp.yValueAxis.labels.boxAnchor = 'e'
    lp.yValueAxis.valueMin = 0

    # Calculate y-axis max rounded to the nearest 100
    max_value = max(month_0_data, month_1_data, month_2_data, month_3_data, month_4_data, month_5_data)
    lp.yValueAxis.valueMax = round(max_value + 50, -2)  # Adding 50 before rounding for better scaling
    lp.yValueAxis.valueStep = 100
    lp.yValueAxis.visibleGrid = 1
    y_axis_label = String(-40, 110, "Carbon Emissions (lbs)", fontSize=9, fillColor=colors.black)
    drawing.add(y_axis_label)  # Add label to the drawing

    # Add manual month labels below X-axis
    for i, month in enumerate(months):
        drawing.add(String(50 + (i * 80), 30, month, fontSize=10, fillColor=colors.black))

    drawing.add(lp)
    
    return drawing

def get_last_6_months():
    """Returns a list of last 6 months in 'MMM YYYY' format (e.g., 'Mar 2024')."""
    today = datetime.today()
    months = [(today - timedelta(days=30 * i)).strftime("%b %Y") for i in range(5, -1, -1)]
    return months

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

# ========================================================================================================
# ============================================= Page Setup ===============================================
# ========================================================================================================

    response = HttpResponse(content_type='application/pdf')
    response['Content-Disposition'] = 'attachment; filename="environmental_impact_report.pdf"'

    doc = SimpleDocTemplate(response, pagesize=letter, topMargin=20, bottomMargin=20, leftMargin=45, rightMargin=45)
    elements = []
    styles = getSampleStyleSheet()

    centered_style_heading2 = ParagraphStyle(
        'CenteredStyle',
        parent=styles['Heading2'], 
        alignment=TA_CENTER
    )

# ========================================================================================================
# ============================================= Data Retrieval ===========================================
# ========================================================================================================

    # Calculate the date one year ago from today
    today = timezone.now().date()

    one_year_ago = today - timedelta(days=365)

    # Calculate the date one month ago from today
    one_month_ago = today - timedelta(days=30)

    # Filter the data from one year ago to today
    db_data = RouteEnvData.objects.filter(date__gte=one_year_ago)

# ========================================================================================================
# ============================================= Data Calculations ========================================
# ========================================================================================================

    # Extract field names (table headers)
    field_names = [field.verbose_name if field.verbose_name else field.name for field in RouteEnvData._meta.fields]

    # Prepare table data (headers + records)
    route_table_data = [field_names]  # Add headers as the first row

    # Initialize aggregated values
    total_distance_current_month = 0
    total_fuel_consumption_current_month = 0
    total_carbon_emissions_current_month = 0
    total_energy_consumption_current_month = 0
    total_cost_current_month = 0

    total_distance_year = 0
    total_fuel_consumption_year = 0
    total_carbon_emissions_year = 0
    total_energy_consumption_year = 0
    total_cost_year = 0

    total_distance_last_month = 0
    total_fuel_consumption_last_month = 0
    total_carbon_emissions_last_month = 0
    total_energy_consumption_last_month = 0
    total_cost_last_month = 0

    for obj in db_data:
        distance = obj.distance
        mpg = obj.mpg

        # Calculate aggregated values for the year
        total_distance_year += distance
        total_fuel_consumption_year += (distance / mpg)  # Fuel consumption = Distance / MPG
        total_carbon_emissions_year += calculate_carbon_emissions_per_route(distance, mpg)
        total_energy_consumption_year += calculate_energy_consumption_per_route(distance, mpg)
        total_cost_year += calculate_cost_per_route(distance, mpg, 3.095)  

        # Calculate aggregated values for the current month
        if obj.date > one_month_ago:
            total_distance_current_month += distance
            total_fuel_consumption_current_month += (distance / mpg)
            total_carbon_emissions_current_month += calculate_carbon_emissions_per_route(distance, mpg)
            total_energy_consumption_current_month += calculate_energy_consumption_per_route(distance, mpg)
            total_cost_current_month += calculate_cost_per_route(distance, mpg, 3.095)

            row = [str(getattr(obj, field.name)) for field in RouteEnvData._meta.fields]
            route_table_data.append(row)

        # Calculate aggregated values for the last month
        if obj.date > one_month_ago - timedelta(days=30) and obj.date < one_month_ago:

            total_distance_last_month += distance
            total_fuel_consumption_last_month += (distance / mpg)  # Fuel consumption = Distance / MPG
            total_carbon_emissions_last_month += calculate_carbon_emissions_per_route(distance, mpg)
            total_energy_consumption_last_month += calculate_energy_consumption_per_route(distance, mpg)
            total_cost_last_month += calculate_cost_per_route(distance, mpg, 3.095)

    # Calculate averages
    avg_mpg_last_month = total_distance_last_month / total_fuel_consumption_last_month if total_fuel_consumption_last_month else 0
    avg_carbon_emissions_last_month = total_carbon_emissions_last_month / total_distance_last_month if total_distance_last_month else 0
    avg_cost_per_mile_last_month = total_cost_last_month / total_distance_last_month if total_distance_last_month else 0

    avg_mpg_current_month = total_distance_current_month / total_fuel_consumption_current_month if total_fuel_consumption_current_month else 0
    avg_carbon_emissions_current_month = total_carbon_emissions_current_month / total_distance_current_month if total_distance_current_month else 0
    avg_cost_per_mile_current_month = total_cost_current_month / total_distance_current_month if total_distance_current_month else 0

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
    
    title_style = ParagraphStyle(
        'TitleStyle',
        parent=styles['Title'],
        fontSize=20,
        textColor=colors.darkgreen,
        alignment=1 
    )

    elements.append(Paragraph("Environmental Impact Report", title_style))
    elements.append(Spacer(1, 20))

# ========================================================================================================
# ================================== Aggregated Data For Last Month ======================================
# ========================================================================================================
    
    elements.append(Paragraph("Aggregated Data for the Last Month", centered_style_heading2))

    aggregated_data= [("Metric", "% Diff from Last Month")]
    aggregated_data_temp = [
        (f"Total Distance Traveled: {total_distance_current_month:.2f} miles", f"{calculate_percentage_change(total_distance_last_month, total_distance_current_month)}% change"),
        (f"Total Fuel Consumption: {total_fuel_consumption_current_month:.2f} gallons", f"{calculate_percentage_change(total_fuel_consumption_last_month, total_fuel_consumption_current_month)}% change"),
        (f"Total Carbon Emissions: {total_carbon_emissions_current_month:.2f} lbs", f"{calculate_percentage_change(total_carbon_emissions_last_month, total_carbon_emissions_current_month)}% change"),
        (f"Total Energy Consumption: {total_energy_consumption_current_month:.2f} gallons", f"{calculate_percentage_change(total_energy_consumption_last_month, total_energy_consumption_current_month)}% change"),
        (f"Average Miles per Gallon (MPG): {avg_mpg_current_month:.2f}", f"{calculate_percentage_change(avg_mpg_last_month, avg_mpg_current_month)}% change"),
        (f"Average Carbon Emissions per Mile: {avg_carbon_emissions_current_month:.2f} lbs/mile", f"{calculate_percentage_change(avg_carbon_emissions_last_month, avg_carbon_emissions_current_month)}% change"),
        (f"Average Cost per Mile: {avg_cost_per_mile_current_month:.2f} dollars/mile", f"{calculate_percentage_change(avg_cost_per_mile_last_month, avg_cost_per_mile_current_month)}% change")
    ]

    aggregated_data.extend(aggregated_data_temp)
    aggregated_data_table = [(Paragraph(row[0], styles['BodyText']), Paragraph(row[1], styles['BodyText'])) for row in aggregated_data]

    aggregated_table = Table(aggregated_data_table, colWidths=[300, 100])
    aggregated_table.setStyle(TableStyle([
        ('GRID', (0,0), (-1,-1), 0.5, colors.grey),  
        ('ALIGN', (0,0), (0,-1), 'LEFT'),  
        ('ALIGN', (1,0), (-1,-1), 'RIGHT'), 
        ('VALIGN', (0,0), (-1,-1), 'MIDDLE'),  
        ('TEXTCOLOR', (1,0), (1,-1), colors.red),
        ('GRID', (0, 0), (-1, -1), 1, colors.white)
    ]))

    elements.append(aggregated_table)
    elements.append(Spacer(1, 10))

# ========================================================================================================
# ================================== Aggregated Data For Last Year =======================================
# ========================================================================================================

    elements.append(Paragraph("Aggregated Data for the Last Year", centered_style_heading2))
    elements.append(Spacer(1, 10))

    aggregated_data = [
        [f"Total Distance Traveled: {total_distance_year:.2f} miles"],
        [f"Total Fuel Consumption: {total_fuel_consumption_year:.2f} gallons"],
        [f"Total Carbon Emissions: {total_carbon_emissions_year:.2f} lbs"],
        [f"Total Energy Consumption: {total_energy_consumption_year:.2f} gallons"],
        [f"Average Miles per Gallon (MPG): {avg_mpg_year:.2f}"],
        [f"Average Carbon Emissions per Mile: {avg_carbon_emissions_year:.2f} lbs/mile"],
        [f"Average Cost per Mile: {avg_cost_per_mile_year:.2f} dollars/mile"]
    ]

    aggregated_data_table = [[Paragraph(row[0], styles['BodyText'])] for row in aggregated_data]
    aggregated_table = Table(aggregated_data_table, colWidths=[400])
   
    elements.append(aggregated_table)

# ========================================================================================================
# ================================== Graphs ==============================================================
# ========================================================================================================

    elements.append(Paragraph("Carbon Emissions", centered_style_heading2))

    # Create a line graph for carbon emissions
    carbon_emmision_graph = create_line_chart(db_data)
    elements.append(carbon_emmision_graph)

# ========================================================================================================
# ================================== Route Table ==============================================================
# ========================================================================================================

    # Make table stretch across the page
    page_width, _ = letter
    col_widths = [(page_width - 100) / len(field_names)] * len(field_names)

    route_table = Table(route_table_data, colWidths=col_widths)
    route_table.setStyle(TableStyle([
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

    elements.append(route_table)
    elements.append(Spacer(1, 30))

    # Build PDF
    doc.build(elements)
    return response
