package feyd.tengen.fire_alarm.dao;

import feyd.tengen.fire_alarm.model.Device;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class deviceDAO extends DAO{

    public deviceDAO(){
        super();
    }

    public List<Device> getAllDevices(int userId){

        List<Device> list = new ArrayList<>();
        PreparedStatement ps = null;
        ResultSet rs = null;

        try{
            String query = "SELECT * FROM fire_alarm.devices where user_id = ?;";
            ps = conn.prepareStatement(query);
            ps.setInt(1, userId);
            rs = ps.executeQuery();

            while (rs.next()){
                list.add(Device.builder()
                        .id(rs.getInt(1))
                        .name(rs.getString(2))
                        .location(rs.getString(3))
                        .user_id(rs.getInt(4))
                        .build());
            }
            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }

    public Device getDeviceById(int deviceId){

        PreparedStatement ps = null;
        ResultSet rs = null;

        try{
            String query = "SELECT * FROM fire_alarm.devices where id = ?;";
            ps = conn.prepareStatement(query);
            ps.setInt(1, deviceId);
            rs = ps.executeQuery();

            if (rs.next()){
                 return Device.builder()
                        .id(rs.getInt(1))
                        .name(rs.getString(2))
                        .location(rs.getString(3))
                        .user_id(rs.getInt(4))
                        .build();
            } else {
                return null;
            }

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }
    }
}
