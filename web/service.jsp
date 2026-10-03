<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@page import="java.sql.*, util.*"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Select Service Category — Urban Genie</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<%
String name = (String) session.getAttribute("name");
%>
  <style>
    .category-selection-grid {
      display: grid;
      grid-template-columns: repeat(auto-fit, minmax(210px, 1fr));
      gap: 18px;
      margin-top: 20px;
    }
    .cat-btn {
      background: #ffffff;
      border: 1px solid var(--border-subtle);
      border-radius: var(--radius-md);
      padding: 24px 18px;
      text-align: center;
      text-decoration: none;
      color: var(--text-main);
      box-shadow: var(--shadow-xs);
      transition: all var(--transition-fast);
      display: flex;
      flex-direction: column;
      align-items: center;
      cursor: pointer;
    }
    .cat-btn:hover {
      transform: translateY(-2px);
      box-shadow: var(--shadow-md);
      border-color: var(--primary-border);
      color: var(--primary);
    }
    .cat-btn i {
      font-size: 1.8rem;
      color: var(--primary);
      margin-bottom: 12px;
      transition: transform var(--transition-fast);
    }
    .cat-btn:hover i {
      transform: scale(1.1);
    }
    .cat-btn h4 {
      font-size: 1rem;
      font-weight: 600;
      margin-bottom: 4px;
    }
    .cat-btn span {
      font-size: 0.78rem;
      color: var(--text-muted);
    }
  </style>
</head>
<body style="background: var(--bg-app);">

  <!-- Navbar -->
  <header class="app-header">
    <div class="navbar">
      <a href="index.html" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--primary);"></i>
        Urban Genie
      </a>
      <div style="display: flex; gap: 10px;">
        <% if (name != null) { %>
          <a href="userprofile111.jsp" class="btn btn-outline btn-sm">
            <i class="fa-solid fa-gauge"></i> Dashboard
          </a>
        <% } else { %>
          <a href="user.jsp" class="btn btn-primary btn-sm">
            <i class="fa-solid fa-arrow-right-to-bracket"></i> Sign In
          </a>
          <a href="index.html" class="btn btn-outline btn-sm">
            <i class="fa-solid fa-house"></i> Home
          </a>
        <% } %>
      </div>
    </div>
  </header>

  <main class="app-container">
    <div class="action-bar">
      <div class="page-heading">
        <h1>Select a Service Category</h1>
        <p>Choose the trade you need assistance with in Ambajogai</p>
      </div>
      <!-- Instant Live Filter Box -->
      <div class="search-box">
        <i class="fa-solid fa-magnifying-glass"></i>
        <input type="text" id="catSearchInput" placeholder="Filter categories (e.g. plumber, car)..." onkeyup="filterGrid('catSearchInput', 'catGrid')">
      </div>
    </div>

    <!-- Interactive Grid Cards -->
    <div id="catGrid" class="category-selection-grid">
      <a href="getservice.jsp?category=Plumber" class="cat-btn">
        <i class="fa-solid fa-wrench"></i>
        <h4>Plumber</h4>
        <span>Taps, pipes & drainage</span>
      </a>

      <a href="getservice.jsp?category=Electronics" class="cat-btn">
        <i class="fa-solid fa-bolt"></i>
        <h4>Electronics</h4>
        <span>Wiring, switches & appliances</span>
      </a>

      <a href="getservice.jsp?category=Carpenter" class="cat-btn">
        <i class="fa-solid fa-hammer"></i>
        <h4>Carpenter</h4>
        <span>Doors, wood & furniture</span>
      </a>

      <a href="getservice.jsp?category=Automobiles" class="cat-btn">
        <i class="fa-solid fa-car"></i>
        <h4>Automobiles</h4>
        <span>Bike & car mechanics</span>
      </a>

      <a href="getservice.jsp?category=Home Cleaning" class="cat-btn">
        <i class="fa-solid fa-broom"></i>
        <h4>Home Cleaning</h4>
        <span>Deep home cleaning</span>
      </a>

      <a href="getservice.jsp?category=Agriculture" class="cat-btn">
        <i class="fa-solid fa-wheat-awn"></i>
        <h4>Agriculture</h4>
        <span>Farm equipment & services</span>
      </a>

      <a href="getservice.jsp?category=Furniture" class="cat-btn">
        <i class="fa-solid fa-couch"></i>
        <h4>Furniture</h4>
        <span>Repairs & fabrication</span>
      </a>

      <a href="getservice.jsp?category=Health & Medical" class="cat-btn">
        <i class="fa-solid fa-heart-pulse"></i>
        <h4>Health & Medical</h4>
        <span>Home care & supplies</span>
      </a>

      <a href="getservice.jsp?category=Transportation" class="cat-btn">
        <i class="fa-solid fa-truck-moving"></i>
        <h4>Transportation</h4>
        <span>Goods & parcel shifting</span>
      </a>

      <a href="getservice.jsp?category=Food" class="cat-btn">
        <i class="fa-solid fa-utensils"></i>
        <h4>Food & Catering</h4>
        <span>Local food services</span>
      </a>
    </div>
  </main>

  <script src="js/main.js"></script>
</body>
</html>