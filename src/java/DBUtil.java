import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

/**
 * DBUtil - Centralized Database Connection Utility
 * Provides a single place to manage JDBC connection settings.
 */
public class DBUtil {

    private static final String DEFAULT_URL  = "jdbc:mysql://localhost:3306/dial?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String DEFAULT_USER = "root";
    private static final String DEFAULT_PASS = "root";

    /**
     * Returns a new JDBC Connection to the 'dial' database.
     * Caller is responsible for closing the connection.
     */
    public static Connection getConnection() throws ClassNotFoundException, SQLException {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            Class.forName("com.mysql.jdbc.Driver");
        }

        String url  = System.getenv("DB_URL");
        if (url == null || url.trim().isEmpty()) {
            url = System.getProperty("db.url", DEFAULT_URL);
        }

        String user = System.getenv("DB_USER");
        if (user == null || user.trim().isEmpty()) {
            user = System.getProperty("db.user", DEFAULT_USER);
        }

        String pass = System.getenv("DB_PASS");
        if (pass == null) {
            pass = System.getProperty("db.pass", DEFAULT_PASS);
        }

        return DriverManager.getConnection(url, user, pass);
    }

    /**
     * Safely close a connection (null-safe).
     */
    public static void close(Connection c) {
        if (c != null) {
            try { c.close(); } catch (SQLException e) { /* ignored */ }
        }
    }
}
