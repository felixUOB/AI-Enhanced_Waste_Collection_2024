var map = L.map('map').setView([51.505, -0.09], 13);

L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
  maxZoom: 19,
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);
var marker;

// Fetch the stops data from JSON endpoint
fetch('/stops/get_stops_list')
  .then(response => response.json())
  .then(stops => {
    // Iterate over each stop and create a marker
    for (let stop of stops) {
      L.marker([stop.latitude, stop.longitude])
        .addTo(map)
        .bindPopup(stop.location_name);
    }
    if (stops.length > 0) map.setView([stops[0].latitude, stops[0].longitude], 13);
  })
  .catch(error => console.error('Error fetching stops:', error));