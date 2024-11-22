<%@ page import="java.util.List" %>
<%@ page import="feyd.tengen.fire_alarm.dao.sensorDataDAO" %>
<%@ page import="feyd.tengen.fire_alarm.model.SensorData" %>
<%@ page import="feyd.tengen.fire_alarm.model.Device" %>
<%@ page import="feyd.tengen.fire_alarm.dao.deviceDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html>
<head>
    <title>History</title>
    <meta charset="UTF-8">
    <style>
        body {
            display: flex;
            flex-direction: column;
            align-items: center;
            justify-content: center;
            height: 100vh;
            margin: 0;
            background-color: #f0f0f0;
        }
        .table-container {
            max-height: 300px;
            overflow: auto;
            border: 1px solid #ddd;
            margin-bottom: 10px;
        }
        table {
            border-collapse: collapse;
            width: 600px;
        }
        table, th, td {
            border: 1px solid black;
            padding: 10px;
        }
        caption {
            font-weight: bold;
            font-size: 18px;
            padding: 10px;
            text-align: center;
            text-transform: uppercase;
        }
        .buttons {
            margin-top: 10px;
            display: flex;
            justify-content: center;
            text-align: center;
        }
        .buttons button {
            background-color: royalblue;
            margin: 5px 10px;
            color: #fff;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }

        button:hover{
            background-color: blue;
        }

        tr:nth-child(even) {
            background-color: #D6EEEE;
        }
    </style>
</head>

<body>

<%
    int deviceId = Integer.parseInt(request.getParameter("deviceId"));
    deviceDAO deviceDAO = new deviceDAO();
    Device device = deviceDAO.getDeviceById(deviceId);
%>
<h1>Lịch sử báo cháy của thiết bị <%=device.getName()%>:</h1>

<div class="table-container">
    <table>
        <tr>
            <th>ID</th>
            <th>Time</th>
            <th>Temperature</th>
            <th>Humidity</th>
        </tr>
        <%

            sensorDataDAO sensorDataDAODAO = new sensorDataDAO();
            List<SensorData> history = sensorDataDAODAO.getHistory(deviceId);

            if (history != null) {
                int index = 1;
                for (SensorData buzzer : history) {
        %>
        <tr>
            <td><%= index++ %></td>
            <td><%= buzzer.getTime() %></td>
            <td><%= buzzer.getTemp() %></td>
            <td><%= buzzer.getHumid() %></td>

        </tr>
        <%
            }
        }
        %>

    </table>

</div>

<div class="buttons" style="text-align: right;">
    <button onclick="window.history.back()">Quay lại</button>
</div>
</body>
</html>
