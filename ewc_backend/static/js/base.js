document.addEventListener("DOMContentLoaded", function() {
    const dropdown = document.getElementById("downloadDataDropdown");
    const downloadBtn = document.getElementById("downloadBtn");
    let selectedTable = null;
  
    dropdown.addEventListener("change", function() {
      selectedTable = this.value;
      downloadBtn.disabled = false;
    });
  
    downloadBtn.addEventListener("click", function() {
      if (selectedTable) {
        window.location.href = `/export/?table=${selectedTable}`;
        
      }
      else {
        alert("Please select a table to download.");
      }
    });
  });