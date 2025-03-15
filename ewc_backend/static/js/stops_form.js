document.addEventListener('DOMContentLoaded', (event) => {
  console.log('DOM loaded, initializing map');
  // Initialize the map
  var map = L.map('map').setView([51.505, -0.09], 13); // Default coordinates and zoom level

  // Add OpenStreetMap tiles
  L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
    attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
  }).addTo(map);

  setTimeout(() => {
    map.invalidateSize();
  }, 100);

  // Function to update the map with new coordinates
  window.updateMap = function(lat, lon) {
    map.setView([lat, lon], 13);
    L.marker([lat, lon]).addTo(map);
  };
});

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
        }
      });
  }