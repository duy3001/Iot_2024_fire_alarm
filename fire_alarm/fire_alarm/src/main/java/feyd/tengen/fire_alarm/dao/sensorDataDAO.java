package feyd.tengen.fire_alarm.dao;

import feyd.tengen.fire_alarm.model.SensorData;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;
import java.util.List;

public class sensorDataDAO extends DAO{

    public sensorDataDAO(){
        super();
    }

    public void addHistory(SensorData data){

        PreparedStatement ps = null;
        ResultSet rs = null;

        LocalDateTime myDateObj = LocalDateTime.now();
        DateTimeFormatter time = DateTimeFormatter.ofPattern("dd-MM-yyyy HH:mm:ss");
        String timeStr = myDateObj.format(time);

        try{

            String query = "INSERT INTO sensor_data (time, temperature, humidity, device_id) VALUES ( ?, ?, ?, ?)";
            ps = conn.prepareStatement(query);
            ps.setString(1, timeStr);
            ps.setString(2, data.getTemp());
            ps.setString(3, data.getHumid());
            ps.setInt(4, data.getDevice_id());

            ps.executeUpdate();

        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }

    public List<SensorData> getHistory(int deviceId){

        PreparedStatement ps = null;
        ResultSet rs = null;
        List<SensorData> list = new ArrayList<>();
        try{
            String query = "SELECT * FROM fire_alarm.sensor_data where device_id = ?;";
            ps = conn.prepareStatement(query);
            ps.setInt(1, deviceId);
            rs = ps.executeQuery();
            while (rs.next()){
                String time = rs.getString(2);
                String temp = rs.getString(3);
                String humid = rs.getString(4);
                int device_id = rs.getInt(5);
                list.add(SensorData.builder()
                        .time(time)
                        .humid(humid)
                        .temp(temp)
                        .device_id(device_id).build()
                );
            }

            return list;
        } catch (SQLException e) {
            throw new RuntimeException(e);
        }

    }
}
