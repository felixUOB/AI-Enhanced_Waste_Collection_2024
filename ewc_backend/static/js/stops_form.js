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