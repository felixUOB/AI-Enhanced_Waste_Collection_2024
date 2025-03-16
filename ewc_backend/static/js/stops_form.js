var map = L.map('map').setView([51.505, -0.09], 13);

L.tileLayer('https://tile.openstreetmap.org/{z}/{x}/{y}.png', {
  maxZoom: 19,
  attribution: '&copy; <a href="http://www.openstreetmap.org/copyright">OpenStreetMap</a>'
}).addTo(map);

// Initialize marker with default position
var marker;

// Function to update the marker
function updateMarker() {
  var lat = parseFloat(document.getElementById('id_latitude').value);
  var lng = parseFloat(document.getElementById('id_longitude').value);

  if (!isNaN(lat) && !isNaN(lng)) {
    if (marker) {
      marker.setLatLng([lat, lng]).update();
    } else {
      marker = L.marker([lat, lng]).addTo(map)
        .bindPopup('Selected Location.')
        .openPopup();
    }
    map.setView([lat, lng], 13);
  }
}

// Event listeners for changes in the fields
document.getElementById('id_latitude').addEventListener('input', updateMarker);
document.getElementById('id_longitude').addEventListener('input', updateMarker);

// Initial marker set (optional, if fields are pre-filled)
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
          updateMarker();
        }
      });
  }