/**
 * Stops Form Map Functionality Script
 *
 * This script initializes a Leaflet map and manages a marker that updates based on 
 * form input values. It also listens for input changes to update the marker location 
 * and performs a debounced coordinate fetch when the stop name input changes.
 *
 * Functions:
 *   - updateMarker(): Updates or adds the map marker based on the current latitude and longitude.
 *   - fetchCoordinates(): Fetches coordinates from the server based on the stop name.
 * 
 * Additional Features - Marker Placement Mode:
 *   - A custom Leaflet control is added that enables a marker placement mode.
 *   - When in placement mode, a floating semi-transparent marker follows the mouse cursor.
 *   - Clicking on the map in placement mode updates the form fields with the selected coordinates 
 *     and drops the marker at the selected location.
 *   - Pressing the Escape key exits marker placement mode.
 *
 * Event Listeners:
 *   - Listens for input changes on 'id_latitude', 'id_longitude', and 'id_location_name' to update the marker.
 *   - Debounced listener on 'stop_name' to trigger coordinate fetching after typing.
 *
 * Dependencies:
 *   - Leaflet library for map handling.
 *   - A backend endpoint '/stops/get_coordinates/' that returns JSON with coordinate data.
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

// Initialize marker with default position
var marker;

// Function to update the marker
function updateMarker() {
  var lat = parseFloat(document.getElementById('id_latitude').value);
  var lng = parseFloat(document.getElementById('id_longitude').value);
  var locationNameField = document.getElementById('id_location_name');
  var popupText = (locationNameField && locationNameField.value.trim()) ? locationNameField.value : 'Selected Location.';


  if (!isNaN(lat) && !isNaN(lng)) {
    if (marker) {
      marker.setLatLng([lat, lng]).update();
      marker.bindPopup(popupText);
      marker.openPopup();
    } else {
      marker = L.marker([lat, lng]).addTo(map)
        .bindPopup(popupText)
        .openPopup();
    }
    map.setView([lat, lng], 13);
  }
}
//
let debounceTimer;
const searchContainer = document.querySelector('.input-group');
document.getElementById('stop_name').addEventListener('input', function() {
  clearTimeout(debounceTimer);
  searchContainer.classList.add('searching');
  const stopName = document.getElementById('stop_name').value;
  if (stopName.trim().length === 0) {
    searchContainer.classList.remove('searching');
    return; // Don't trigger anything if input is empty
  }
  debounceTimer = setTimeout(fetchCoordinates, 1000); // Calls fetchCoordinates 1s after typing stops.
});

// Event listeners for changes in the fields
document.getElementById('id_latitude').addEventListener('input', updateMarker);
document.getElementById('id_longitude').addEventListener('input', updateMarker);
document.getElementById('id_location_name').addEventListener('input', updateMarker);

// Initial marker set
updateMarker();


function fetchCoordinates() {
    const stopName = document.getElementById('stop_name').value;
    fetch(`/stops/get_coordinates/?name=${stopName}`)
      .then(response => response.json())
      .then(data => {
        if (data.error) {
          alert(data.error);
          searchContainer.classList.remove('searching');
          
        } else {
          document.getElementById('id_latitude').value = data.latitude;
          document.getElementById('id_longitude').value = data.longitude;
          document.getElementById('id_location_name').value = data.location_name;
          updateMarker();
          searchContainer.classList.remove('searching');
        }
      });
}

// Function that returns the name of the location based on the latitude and longitude values
function reverseGeocode(lat, lng) {
  fetch(`/stops/reverse_geocode/?latitude=${lat}&longitude=${lng}`)
    .then(response => response.json())
    .then(data => {
      if (data.error) {
        alert(data.error);
      } else {
        document.getElementById('id_location_name').value = data.location_name;
        updateMarker();
      }
    })
    .catch(err => console.error('Reverse geocoding error:', err));
}

// Adds a control to the map that allows the user to place a marker directly on the map
const PlaceMarkerControl = L.Control.extend({
  options: {
    position: 'topleft'
  },
  onAdd: function(map) {
    // Creates a container with the 'leaflet-bar' class
    const container = L.DomUtil.create('div', 'leaflet-bar leaflet-control');
    // Adds a link or a button with a marker icon
    container.innerHTML = '<a href="#" id="place-marker-btn" title="Place a Marker" style="font-size: 24px; color:rgb(0, 140, 255);"><i class="bi bi-geo-alt"></i></a>';
    
    L.DomEvent.disableClickPropagation(container);

    return container;
  }
});

// Adds the control to the map
map.addControl(new PlaceMarkerControl());

// Event listener for the place-marker button
document.getElementById('place-marker-btn').addEventListener('click', function(e) {
  e.preventDefault(); 
  togglePlacementMode();
});

// Listen for Escape key to disable placement mode.
document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape' && placementMode) {
    disablePlacementMode();
  }
});

let placementMode = false;
let floatingMarker = null;

// Toggle marker to turn placement mode on/off.
function togglePlacementMode() {
  placementMode = !placementMode;
  if (placementMode) {
    enablePlacementMode();
  } else {
    disablePlacementMode();
  }
}

// When placement mode is enabled, add a listeners that updates a floating semi-transparent marker icon.
function enablePlacementMode() {
  map.on('mousemove', onMapMouseMove);
  map.on('click', onMapClick);

  map.getContainer().style.cursor = 'crosshair';
}

// Remove listeners and semi-transparent floating marker after placement mode is disabled.
function disablePlacementMode() {
  map.off('mousemove', onMapMouseMove);
  map.off('click', onMapClick);
  map.getContainer().style.cursor = '';
  if (floatingMarker) {
    map.removeLayer(floatingMarker);
    floatingMarker = null;
  }
  placementMode = false;
}

// On mouse move, position a floating semi-transparent marker at the cursor's location.
function onMapMouseMove(e) {
  if (!floatingMarker) {
    floatingMarker = L.marker(e.latlng, {
      icon: L.icon({
        iconUrl: 'https://unpkg.com/leaflet@1.9.4/dist/images/marker-icon.png',
        iconSize: [25, 41],
        iconAnchor: [12, 41]
      }),
      interactive: false,
      opacity: 0.7
    }).addTo(map);
  } else {
    floatingMarker.setLatLng(e.latlng);
  }
}

// When the user clicks on the map in placement mode, update the form and place the marker.
function onMapClick(e) {
  const lat = e.latlng.lat;
  const lng = e.latlng.lng;
  
  // Update the form fields with lat and lng values.
  document.getElementById('id_latitude').value = lat;
  document.getElementById('id_longitude').value = lng;
  
 
  updateMarker();

  // Fetch and update the location name automatically when adding a stop on the map.
  reverseGeocode(lat, lng);
  
  disablePlacementMode();
}
// This function adds a control to the map that allows the user to switch between map templates
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


// Event listener for the map-switcher button
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