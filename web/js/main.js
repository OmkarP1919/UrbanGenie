/**
 * URBAN GENIE - Core Vanilla JavaScript Utilities
 */

function togglePasswordVisibility(inputId, iconId) {
  const input = document.getElementById(inputId);
  const icon = document.getElementById(iconId);
  if (!input || !icon) return;

  if (input.type === 'password') {
    input.type = 'text';
    icon.classList.remove('fa-eye');
    icon.classList.add('fa-eye-slash');
  } else {
    input.type = 'password';
    icon.classList.remove('fa-eye-slash');
    icon.classList.add('fa-eye');
  }
}

// Client-side form validation helper
function validateForm(formId) {
  const form = document.getElementById(formId);
  if (!form) return true;

  const phone = form.querySelector('input[name="no"]');
  if (phone && phone.value.trim().length > 0) {
    const phoneRegex = /^\d{10}$/;
    if (!phoneRegex.test(phone.value.trim())) {
      alert('Please enter a valid 10-digit mobile number.');
      phone.focus();
      return false;
    }
  }

  const pwd = form.querySelector('input[name="pwd"]');
  if (pwd && pwd.value.trim().length > 0 && pwd.value.trim().length < 4) {
    alert('Password must be at least 4 characters long.');
    pwd.focus();
    return false;
  }

  return true;
}

// Confirmation helper for delete or critical operations
function confirmAction(message, redirectUrl) {
  if (confirm(message)) {
    window.location.href = redirectUrl;
  }
  return false;
}

// Auto forward on page load (prevent cached back history if needed)
function setupPreventBack() {
  window.history.forward();
  window.onunload = function () { null; };
}

// Real-time table filter by search query
function filterTable(inputId, tableId) {
  const query = document.getElementById(inputId).value.toLowerCase().trim();
  const table = document.getElementById(tableId);
  if (!table) return;
  const rows = table.querySelectorAll('tbody tr');
  rows.forEach(row => {
    // If it's an empty-state row, don't hide
    if (row.classList.contains('empty-state-row')) return;
    const text = row.innerText.toLowerCase();
    row.style.display = text.includes(query) ? '' : 'none';
  });
}

// Filter table rows by status tab (All / Pending / Approved)
function filterTableByStatus(arg1, tableId, arg3) {
  let targetStatus = 'all';
  let btnElement = null;

  if (typeof arg1 === 'string') {
    targetStatus = arg1;
    btnElement = arg3;
  } else {
    btnElement = arg1;
    targetStatus = arg3;
  }

  if (btnElement && btnElement.parentElement) {
    btnElement.parentElement.querySelectorAll('.filter-tab').forEach(tab => tab.classList.remove('active'));
    btnElement.classList.add('active');
  }

  const table = document.getElementById(tableId);
  if (!table) return;
  const rows = table.querySelectorAll('tbody tr');
  rows.forEach(row => {
    if (row.classList.contains('empty-state-row') || row.querySelector('.empty-state')) return;
    if (targetStatus === 'all') {
      row.style.display = '';
    } else {
      const rowStatus = (row.getAttribute('data-status') || '').toLowerCase();
      row.style.display = (rowStatus === targetStatus.toLowerCase()) ? '' : 'none';
    }
  });
}

// Real-time grid card filter
function filterGrid(inputId, gridId) {
  const query = document.getElementById(inputId).value.toLowerCase().trim();
  const grid = document.getElementById(gridId);
  if (!grid) return;
  const items = grid.children;
  Array.from(items).forEach(item => {
    const text = item.innerText.toLowerCase();
    item.style.display = text.includes(query) ? '' : 'none';
  });
}

// Interactive Star Rating Selector
function setupStarRating(containerId, hiddenInputId, labelId) {
  const container = document.getElementById(containerId);
  const input = document.getElementById(hiddenInputId);
  const label = document.getElementById(labelId);
  if (!container || !input) return;

  const stars = container.querySelectorAll('i');
  const labels = {
    1: '1 Star — Poor Service',
    2: '2 Stars — Fair',
    3: '3 Stars — Good Service',
    4: '4 Stars — Very Good',
    5: '5 Stars — Excellent Experience'
  };

  stars.forEach(star => {
    star.addEventListener('click', function () {
      const val = parseInt(this.getAttribute('data-val'));
      input.value = val;
      if (label) label.textContent = labels[val] || (val + ' Stars');
      stars.forEach(s => {
        const sVal = parseInt(s.getAttribute('data-val'));
        if (sVal <= val) {
          s.classList.add('active');
          s.classList.remove('fa-regular');
          s.classList.add('fa-solid');
        } else {
          s.classList.remove('active');
          s.classList.remove('fa-solid');
          s.classList.add('fa-regular');
        }
      });
    });

    star.addEventListener('mouseover', function () {
      const val = parseInt(this.getAttribute('data-val'));
      stars.forEach(s => {
        const sVal = parseInt(s.getAttribute('data-val'));
        if (sVal <= val) s.classList.add('hovered');
        else s.classList.remove('hovered');
      });
    });

    star.addEventListener('mouseout', function () {
      stars.forEach(s => s.classList.remove('hovered'));
    });
  });
}

// Export any HTML table directly to a CSV spreadsheet download
function exportTableToCSV(tableId, filename) {
  const table = document.getElementById(tableId);
  if (!table) return;

  const rows = table.querySelectorAll('tr');
  const csvData = [];

  rows.forEach(row => {
    if (row.style.display === 'none' || row.classList.contains('empty-state-row')) return;
    const cols = row.querySelectorAll('th, td');
    const rowData = [];
    cols.forEach(col => {
      // Skip actions column containing buttons
      if (col.querySelector('button, a.btn')) return;
      let text = col.innerText.replace(/(\r\n|\n|\r)/gm, ' ').replace(/\s+/g, ' ').trim();
      text = text.replace(/"/g, '""');
      rowData.push('"' + text + '"');
    });
    if (rowData.length > 0) {
      csvData.push(rowData.join(','));
    }
  });

  const csvString = '\uFEFF' + csvData.join('\r\n');
  const blob = new Blob([csvString], { type: 'text/csv;charset=utf-8;' });
  const url = URL.createObjectURL(blob);
  const link = document.createElement('a');
  link.setAttribute('href', url);
  link.setAttribute('download', filename || 'export.csv');
  link.style.visibility = 'hidden';
  document.body.appendChild(link);
  link.click();
  document.body.removeChild(link);
}

// Filter table rows by locality / area in Ambajogai
function filterTableByArea(area, btnElement, tableId) {
  if (btnElement && btnElement.parentElement) {
    btnElement.parentElement.querySelectorAll('.area-chip').forEach(c => c.classList.remove('active'));
    btnElement.classList.add('active');
  }

  const table = document.getElementById(tableId);
  if (!table) return;

  const rows = table.querySelectorAll('tbody tr');
  rows.forEach(row => {
    if (row.classList.contains('empty-state-row') || row.querySelector('.empty-state')) return;
    if (area === 'all') {
      row.style.display = '';
    } else {
      const rowArea = (row.getAttribute('data-area') || '').toLowerCase();
      row.style.display = rowArea.includes(area.toLowerCase()) ? '' : 'none';
    }
  });
}