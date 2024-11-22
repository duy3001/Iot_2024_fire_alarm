package feyd.tengen.fire_alarm.dao;

import java.sql.Connection;
import java.sql.DriverManager;

public class DAO {

    public static Connection conn;

    public DAO() {
        if (conn == null) {
            String dbUrl = "jdbc:mysql://localhost:3306/fire_alarm?autoReconnect=true&useSSL=false&allowPublicKeyRetrieval=true";
            String dbClass = "com.mysql.cj.jdbc.Driver";

            try {
                Class.forName(dbClass);
                conn = DriverManager.getConnection(dbUrl, "root", "Hoangduy@123");
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
