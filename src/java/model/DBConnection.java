package model;

import java.sql.Connection;
import java.sql.DriverManager;

public class DBConnection {

    private static Connection conn = null;

    public static Connection getConnection() {
        try {
            if (conn == null || conn.isClosed()) {

                // ✅ Load MySQL Driver
                Class.forName("com.mysql.cj.jdbc.Driver");

                // ✅ Database connection details
                String url = "jdbc:mysql://localhost:3307/expense_tracker_db"; // change DB name if different
                String user = "root";      // your MySQL username
                String pass = "";      // your MySQL password

                // ✅ Establish connection
                conn = DriverManager.getConnection(url, user, pass);
                System.out.println("✅ Database Connected Successfully!");
            }
        } catch (Exception e) {
            System.out.println("❌ Database Connection Error: " + e.getMessage());
        }
        return conn;
    }
}
