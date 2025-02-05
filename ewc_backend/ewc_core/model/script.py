import pandas as pd
from datetime import datetime, timedelta

# Define waste accumulation rates (kg per week)
stops = {
    "Stop A": 4,
}

# Define start date and weeks of data
start_date = datetime(2024, 1, 1)
num_weeks = 52  # Adjust as needed

data = []

target_days = [start_date + timedelta(days=i * 7) for i in range(num_weeks)]

for week_start in target_days:
    for stop, rate in stops.items():
        data.append({
            "ds": week_start.strftime("%Y-%m-%d"),
            "y": rate
        })

# Create DataFrame
df = pd.DataFrame(data)

# Save to CSV
df.to_csv("waste_collection_data.csv", index=False)
