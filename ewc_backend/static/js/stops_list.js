var map = L.map('map').setView([51.505, -0.09], 13);

L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>, &copy; <a href="https://carto.com/">CARTO</a>',
    subdomains: 'abcd',
    maxZoom: 19
}).addTo(map);
var marker;

// Fetch the stops data from JSON endpoint
fetch('/stops/get_stops_list')
  .then(response => response.json())
  .then(stops => {
    // Iterate over each stop and create a marker
    for (let stop of stops) {
      // Constructs the popup HTML with edit and delete buttons
      var popupHtml = `<strong>${stop.location_name || '(No Name)'}</strong><br>
      <a class="btn btn-sm btn-outline-primary" href="/stops/${stop.stop_id}/edit/">
        <i class="bi bi-pencil"></i> Edit
      </a>
      <a class="btn btn-sm btn-outline-danger ms-2" href="/stops/${stop.stop_id}/delete/">
        <i class="bi bi-trash"></i> Delete
      </a>`;


      L.marker([stop.latitude, stop.longitude])
        .addTo(map)
        .bindPopup(popupHtml);
    }
    if (stops.length > 0) map.setView([stops[0].latitude, stops[0].longitude], 13);
  })
  .catch(error => console.error('Error fetching stops:', error));