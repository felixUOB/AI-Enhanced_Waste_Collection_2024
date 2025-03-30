/**
 * Stops List Map Script
 * 
 * This script initializes a Leaflet map and fetches stops data from a JSON endpoint.
 * It creates markers for each stop and binds a popup containing Edit and Delete buttons.
 * It also sorts the stos list based on the selected dropdown option.
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

let markersLayer = L.layerGroup().addTo(map);
let stopsData = [];

function renderStops(stopsArray) {
  markersLayer.clearLayers();

  const stopsListElement = document.getElementById('stops-list');
  if (stopsListElement) {
    stopsListElement.innerHTML = '';
  }

  // Center the map on the first stop, if available
  if (stopsArray.length > 0) {
    map.setView([stopsArray[0].latitude, stopsArray[0].longitude], 13);
  }

  // Add each stop as a marker 
  stopsArray.forEach(stop => {
    let popupHtml = `<strong>${stop.location_name || '(No Name)'}</strong><br>
      <a class="btn btn-sm btn-outline-primary" href="/stops/${stop.stop_id}/edit/">
        <i class="bi bi-pencil"></i> Edit
      </a>
      <a class="btn btn-sm btn-outline-danger ms-2" href="/stops/${stop.stop_id}/delete/">
        <i class="bi bi-trash"></i> Delete
      </a>`;
    let marker = L.marker([stop.latitude, stop.longitude])
      .bindPopup(popupHtml);
    markersLayer.addLayer(marker);
    // Render list of stops
    if (stopsListElement) {
      const listItem = document.createElement('li');
      listItem.className = 'list-group-item d-flex justify-content-between align-items-center';
      listItem.innerHTML = `
        <div>
          <strong>${stop.location_name || '(No Name)'}</strong><br>
          <span class="text-muted">
            Lat: ${stop.latitude}, Lng: ${stop.longitude} &middot; Max Weight: ${stop.max_weight}
          </span>
        </div>
        <div>
          <a class="btn btn-sm btn-outline-primary" href="/stops/${stop.stop_id}/edit/">
            <i class="bi bi-pencil"></i> Edit
          </a>
          <a class="btn btn-sm btn-outline-danger ms-2" href="/stops/${stop.stop_id}/delete/">
            <i class="bi bi-trash"></i> Delete
          </a>
        </div>
      `;
      stopsListElement.appendChild(listItem);
    }
  });
}

// Fetch stops data from the backend JSON endpoint
fetch('/stops/get_stops_list/')
  .then(response => response.json())
  .then(stops => {
    stopsData = stops;
    renderStops(stopsData);
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


// Wait for the DOM to be fully loaded
document.addEventListener('DOMContentLoaded', function() {
  const sortDropdown = document.getElementById('sortDropdown');
  if (sortDropdown) {
    // Listen to the change event of the dropdown
    sortDropdown.addEventListener('change', function(e) {
      let sortOrder = e.target.value;
      let sortedStops = [...stopsData];
      // Sort by alphabetical order
      if (sortOrder === 'alphabetical') {
        sortedStops.sort((a, b) => {
          const nameA = a.location_name ? a.location_name.toLowerCase() : '';
          const nameB = b.location_name ? b.location_name.toLowerCase() : '';
          return nameA.localeCompare(nameB);
        });
      // Sort by weight
      } else if (sortOrder === 'weight') {
        sortedStops.sort((a, b) =>b.max_weight- a.max_weight);
      }
      renderStops(sortedStops);
    });
  }
});