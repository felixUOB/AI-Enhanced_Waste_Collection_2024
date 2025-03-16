var map = L.map('map').setView([51.505, -0.09], 13);

L.tileLayer('https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png', {
  attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a>, &copy; <a href="https://carto.com/">CARTO</a>',
  subdomains: 'abcd',
  maxZoom: 19
}).addTo(map);

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

let debounceTimer;
document.getElementById('stop_name').addEventListener('input', function() {
  clearTimeout(debounceTimer);
  const stopName = document.getElementById('stop_name').value;
  if (stopName.trim().length === 0) {
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
        } else {
          document.getElementById('id_latitude').value = data.latitude;
          document.getElementById('id_longitude').value = data.longitude;
          document.getElementById('id_location_name').value = data.location_name;
          updateMarker();
        }
      });
  }