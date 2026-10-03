/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */

import javax.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import static java.lang.System.out;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

/**
 *
 * @author AIT
 */
public class email extends HttpServlet {

    /**
     * Processes requests for both HTTP <code>GET</code> and <code>POST</code>
     * methods.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    protected void processRequest(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("text/html;charset=UTF-8");
        try (PrintWriter out = response.getWriter()) {
            // Read credentials from environment variables or web.xml init-params
            String envUser = System.getenv("MAIL_USERNAME");
            final String username = (envUser != null && !envUser.trim().isEmpty()) ? envUser : getInitParameter("mail.username");
            
            String envPass = System.getenv("MAIL_PASSWORD");
            final String passwordEmail = (envPass != null && !envPass.trim().isEmpty()) ? envPass : getInitParameter("mail.password");
            
            String to = request.getParameter("uemail");
            String shop = request.getParameter("shop");

            if (to == null || !to.contains("@")) {
                out.println("<script>alert('Invalid customer email address. Cannot send notification.'); location.href='providerprofile.jsp';</script>");
                return;
            }
        Properties props = new Properties();
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true");
        props.put("mail.smtp.host", "smtp.gmail.com"); // Replace with your email provider's SMTP server
        props.put("mail.smtp.port", "587"); // Replace with your email provider's SMTP port

        Session session = Session.getInstance(props, new Authenticator() {
            @Override
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, passwordEmail);
            }
        });

        try {
            Message message = new MimeMessage(session);
            message.setFrom(new InternetAddress(username));
            message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(to));
            message.setSubject("Your Service Request Received Successfully");
            message.setText("Dear Customer,\n\n"
                    + "We received your Service Request.\n"
                    + "We will contact you soon. \n\n"
                    + "Shop Name: " + shop
                    + "\n\nThank you for choosing Urban Genie.");

            Transport.send(message);
            out.println("<script>alert('Email notification sent successfully to customer!'); location.href='providerprofile.jsp';</script>");
        } catch (MessagingException e) {
            e.printStackTrace();
            out.println("<script>alert('Unable to send email (Check SMTP connection). Please contact customer directly.'); location.href='providerprofile.jsp';</script>");
        }
        }
    }

    // <editor-fold defaultstate="collapsed" desc="HttpServlet methods. Click on the + sign on the left to edit the code.">
    /**
     * Handles the HTTP <code>GET</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Handles the HTTP <code>POST</code> method.
     *
     * @param request servlet request
     * @param response servlet response
     * @throws ServletException if a servlet-specific error occurs
     * @throws IOException if an I/O error occurs
     */
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        processRequest(request, response);
    }

    /**
     * Returns a short description of the servlet.
     *
     * @return a String containing servlet description
     */
    @Override
    public String getServletInfo() {
        return "Short description";
    }// </editor-fold>

}
