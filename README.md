# 2024-AIEnhancedWasteCollection

# Team Members
| Members                      | Email                                                 |
| ---------------------------- | ----------------------------------------------------- |
| Alex Gordon                  | [em23081@bristol.ac.uk](mailto:em23081@bristol.ac.uk) |
| Ezen Tan                     | [mo23274@bristol.ac.uk](mailto:mo23274@bristol.ac.uk) |
| Felix Coupe                  | [zx23695@bristol.ac.uk](mailto:zx23695@bristol.ac.uk) |
| Henry Shin                   | [bg22915@bristol.ac.uk](mailto:bg22915@bristol.ac.uk) |
| Katie Pambakian              | [yj23812@bristol.ac.uk](mailto:yj23812@bristol.ac.uk) |
| Marek Janiec                 | [qx23239@bristol.ac.uk](mailto:qx23239@bristol.ac.uk) |


# Proposal
In the realm of waste management, there is a significant need for systems that not only
streamline waste collection but also assess the environmental impact of recycling efforts.
Existing solutions often focus solely on collection logistics or impact reporting, lacking
integration between these aspects. This proposal outlines a project to develop an AI-driven
application for optimizing waste collection and a comprehensive system for quantifying
environmental impacts, including carbon footprint reduction and energy savings. This
integrated approach will enhance efficiency in waste management and provide valuable
insights into environmental performance.

# Objectives
Develop an AI-Driven Waste Collection Scheduling App. This proposal aims to tackle Size main components:
- Route Planning and Variables
- User Interface
- Data Reports
- Optimizations
- Scheduling

# Preparatory Route Planning and Variables

In this section, we understand you would like a personalised route per collection truck for a certain area. This route will be optimised by considering different data such as behavioural patterns, load capacity, and environmental impacts.

# User Interface

For the UI we believe that you would like a simple-to-operate application in which you can view routes (similar to google maps), route metrics (speed/time, etc.), environmental impact reports, and receive notifications enabling hands-free use whilst driving. User accounts could be used to access the app to differentiate different driver routes and allow varying access levels to only show statistical reports to certain accounts if the data is sensitive and needs to be restricted for some users.

This will be for OS and Android.

# Data Reports

For statistical analysis, we believe you want an in-depth analysis of relevant ecological metrics displayed in a simplified manner. These could involve fuel consumption, speed, carbon footprint, carbon and energy saving.

# Optimisations

To optimize routes in real-time, metrics based on traffic, load volume and weather will be used to edit routes to ensure travel time is kept to a minimum and the environmental impacts are minimised.
The metrics we will use:
- traffic
- weight of the load
- weather
- areas that their is the most waste

The metrics we aim to minimise:
- fuel consumption
- cost
- emissions
- carbon footprint

# Prediction

We will use data analysis to predict where the most waste is.

# Stakeholders
Municipalities, waste management companies, and environmental organizations seeking to
improve waste collection efficiency and assess the environmental benefits of recycling
programs.

# Value Proposition
This project delivers a holistic solution that not only optimizes waste collection routes
through AI but also provides actionable insights into the environmental impact of recycling
activities. By integrating scheduling with impact reporting, the system supports better
decision-making and enhances sustainability efforts. The unique combination of real-time
optimization and detailed impact quantification sets this project apart in the market.

# Application Features and Description
- AI-Driven Waste Collection Scheduling App:
- Real-Time Route Optimization: AI algorithms adjust routes dynamically based on traffic,
weather, and waste volume.
- Historical Data Analysis: Predictive features based on historical waste collection data.
- Personalization: Custom schedules and notifications based on user behavior.
- Environmental Impact Quantification Tools:
- Carbon Footprint and Energy Savings Calculation:
- Data Collection: Track waste volumes and recycling activities.
- AI Analysis: Estimate carbon footprint reduction and energy savings.
- Reporting: Generate reports on environmental impacts.

# Tools and Resources
- Development Tools: **Python**, machine learning libraries, and app development
frameworks.
- Infrastructure: **Azure VM** for hosting and computation.
- Collaboration and Documentation: **GitHub** for version control and project management.

# User Stories
As a municipal worker, I want an intuitive and easy to use interface that tells me the information clearly. 

As a municipal worker, I want a clear route that is easy to follow. 

As an environmental organization, I want to be able to see the reports on environment impacts and see a reduction in the carbon footprint and energy savings.

As a system manager, I want well documented and modular code that is easy to maintain.

As a waste management company, I want an increase in efficiency and reduction of carbon footprint.

As a legislator, I want secure code which is compliant with data protection.

# Flow
Normal FLow:
1. Open app
2. Navigate to the screen showing the route
3. Follow the map
4. Receive notification if something changes

Exceptional Flow:
1. Open app
2. Navigate to the screen showing the route
3. Go the wrong way
4. Get diverted

# Kanban Chart
[Kanban](https://github.com/orgs/spe-uob/projects/161/views/1)

# Gantte Chart
[Gantte Chart](https://uob-my.sharepoint.com/:x:/g/personal/yj23812_bristol_ac_uk/EfdWH23kdE5HvLSvT2PgaNkBh5i5-XZW6Zx429NoYpNWDw?e=cIhVW5)
