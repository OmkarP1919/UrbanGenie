<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Write Review — Urban Genie</title>

  <link rel="stylesheet" href="css/style.css">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.0/css/all.min.css">

<%
String uname = (String) session.getAttribute("name");
if (uname == null) uname = (String) session.getAttribute("uname");

if (uname == null) {
    response.sendRedirect("user.jsp");
    return;
}

String shop = request.getParameter("shop");
if (shop == null || shop.trim().isEmpty()) {
    response.sendRedirect("feedback.jsp");
    return;
}

session.setAttribute("uname", uname);
session.setAttribute("name", uname);
%>
</head>
<body style="background: var(--bg-app);">

  <!-- Navbar -->
  <header class="app-header">
    <div class="navbar">
      <a href="userprofile111.jsp" class="brand-logo">
        <i class="fa-solid fa-bolt-lightning" style="color: var(--primary);"></i>
        Urban Genie
      </a>
      <div style="display: flex; gap: 10px;">
        <a href="userprofile111.jsp" class="btn btn-outline btn-sm"><i class="fa-solid fa-gauge"></i> Dashboard</a>
      </div>
    </div>
  </header>

  <main class="auth-wrapper">
    <div class="auth-card" style="max-width: 520px;">
      <div class="auth-header">
        <div class="auth-icon" style="background: var(--warning-subtle); color: #b45309;">
          <i class="fa-solid fa-star"></i>
        </div>
        <h2>Review Service Provider</h2>
        <p>Rate the quality, punctuality, and professionalism of <%= shop %></p>
      </div>

      <form action="givefeedback111.jsp" method="post" id="feedbackForm">
        <div class="form-group">
          <label class="form-label">Service Provider / Shop</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-store input-icon"></i>
            <input type="text" name="shop" value="<%= shop %>" class="form-control" readonly>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label">Customer Name</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-user input-icon"></i>
            <input type="text" value="<%= uname %>" class="form-control" readonly>
          </div>
        </div>

        <!-- Interactive 1-to-5 Star Rating -->
        <div class="form-group">
          <label class="form-label">Overall Rating (1 to 5 Stars)</label>
          <input type="hidden" name="rating" id="selectedRating" value="5">
          <div class="star-rating-box">
            <div class="star-rating" id="starContainer">
              <i class="fa-solid fa-star active" data-val="1"></i>
              <i class="fa-solid fa-star active" data-val="2"></i>
              <i class="fa-solid fa-star active" data-val="3"></i>
              <i class="fa-solid fa-star active" data-val="4"></i>
              <i class="fa-solid fa-star active" data-val="5"></i>
            </div>
            <span class="star-label-text" id="starLabel">5 Stars — Excellent Experience</span>
          </div>
        </div>

        <div class="form-group">
          <label class="form-label" for="feedbText">Written Review</label>
          <div class="input-with-icon">
            <i class="fa-solid fa-comment-dots input-icon" style="top: 14px;"></i>
            <textarea id="feedbText" name="feedb" class="form-control" rows="4" placeholder="Share your experience regarding craftsmanship, responsiveness, and pricing..." required></textarea>
          </div>
        </div>

        <div style="margin-top: 24px;">
          <button type="submit" class="btn btn-primary btn-block">
            <i class="fa-solid fa-paper-plane"></i> Publish Review
          </button>
        </div>
      </form>

      <div class="auth-footer">
        <a href="userprofile111.jsp"><i class="fa-solid fa-arrow-left"></i> Cancel</a>
      </div>
    </div>
  </main>

  <script src="js/main.js"></script>
  <script>
    // Initialize interactive star rating
    setupStarRating('starContainer', 'selectedRating', 'starLabel');
  </script>
</body>
</html>