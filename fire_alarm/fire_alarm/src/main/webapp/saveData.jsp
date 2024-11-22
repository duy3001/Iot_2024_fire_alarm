<%@ page import="feyd.tengen.fire_alarm.dao.sensorDataDAO" %>
<%@page import="org.json.JSONObject"%>
<%@ page import="feyd.tengen.fire_alarm.model.SensorData" %>
<%@ page import="java.io.BufferedReader" %>
<%@ page contentType="text/html;charset=UTF-8" %>

<%
    // Lấy dữ liệu từ AJAX request
    try{
        StringBuilder jsonData = new StringBuilder();
        String line;

        // Đọc dữ liệu JSON từ request
        BufferedReader reader = request.getReader();
        while ((line = reader.readLine()) != null) {
            jsonData.append(line);
        }
        JSONObject jsonObject = new JSONObject(jsonData.toString());

        // Lấy giá trị nhiệt độ và độ ẩm từ JSON
        String deviceId = jsonObject.getString("deviceId");
        String temperature = jsonObject.getString("temperature");
        String humidity = jsonObject.getString("humidity");

        // Gọi DAO để lưu dữ liệu
        sensorDataDAO dao = new sensorDataDAO();
        dao.addHistory(SensorData.builder()
                .temp(temperature)
                .humid(humidity)
                .device_id(Integer.parseInt(deviceId))
                .build());

        JSONObject responseJson = new JSONObject();
        responseJson.put("status", "success");
        response.getWriter().write(responseJson.toString());

    } catch (Exception e) {
        response.setStatus(500); // Thiết lập mã lỗi 500 nếu có lỗi xảy ra
        response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
    }
%>

