/**
 * Stops List Map Script
 * 
 * This script initializes a Leaflet map and fetches stops data from a JSON endpoint.
 * It creates markers for each stop and binds a popup containing Edit and Delete buttons.
 *
 * Dependencies:
 *  - Leaflet library for map handling.
 *  - A backend endpoint '/stops/get_stops_list' that returns JSON with stop details.
 */

var map = L.map('map').setView([51.505, -0.09], 13);

// Define the detailed map layer
const osmLayer = L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
  attribution: '&copy; OpenStreetMap contributors',
  maxZoom: 19,
  minZoom: 2
});
// Define simplified map layer
const cartoLayer = L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
  attribution: '&copy; OpenStreetMap contributors, &copy; CARTO',
  subdomains: 'abcd',
  maxZoom: 19,
  minZoom: 2
});

let currentBaseLayer = cartoLayer.addTo(map);

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


// This function adds a control to the map that allows the user to switch between map templates.
const MapSwitcherControl = L.Control.extend({
  options: {
    position: 'topright'
  },
  onAdd: function(map) {
    const container = L.DomUtil.create('div', 'leaflet-bar leaflet-control');
    container.innerHTML = `
      <a href="#" id="map-switcher-btn" title="Switch Map Template" style="font-size: 24px; color:rgb(0, 140, 255);">
        <i class="bi bi-layers"></i>
      </a>`;
    L.DomEvent.disableClickPropagation(container);
    return container;
  }
});

map.addControl(new MapSwitcherControl());

// Event listener for the map-switcher button.
document.addEventListener('click', function(e) {
  const switcher = e.target.closest('#map-switcher-btn');
  if (switcher) {
    e.preventDefault();
    map.removeLayer(currentBaseLayer);
    if (currentBaseLayer === osmLayer) {
      currentBaseLayer = cartoLayer;
    } else {
      currentBaseLayer = osmLayer;
    }
    map.addLayer(currentBaseLayer);
  }
});