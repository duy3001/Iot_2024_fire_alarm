package feyd.tengen.fire_alarm.dao;

import feyd.tengen.fire_alarm.model.User;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class userDAO extends DAO{

    public userDAO (){
        super();
    }

    public User checkLogin(String username, String password) throws SQLException{

        PreparedStatement ps = null;
        ResultSet rs = null;
        try{
            String query = "SELECT * FROM users where username = ?;";
            ps = conn.prepareStatement(query);
            ps.setString(1, username);
            rs = ps.executeQuery();

            if( rs.next() && password.equals(rs.getString(4))){
                int id = rs.getInt(1);
                String name = rs.getString(2);
                return User.builder()
                        .id(id)
                        .name(name)
                        .build();
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
        return null;
    }
}
