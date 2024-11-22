<%@ page import="feyd.tengen.fire_alarm.dao.deviceDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="feyd.tengen.fire_alarm.model.Device" %>
<%@ page import="feyd.tengen.fire_alarm.model.User" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<html lang="en">
<head>
    <title>Devices</title>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">

    <style>
        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
        }

        .container {
            width: 80%;
            margin: 50px auto;
            text-align: center;
            border: 1px solid #000;
            padding: 20px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }

        h1 {
            font-size: 24px;
            margin-bottom: 20px;
        }

        table {
            width: 100%;
            border-collapse: collapse;
            margin: 0 auto;
        }

        table th, table td {
            border: 1px solid #000;
            padding: 10px;
            text-align: center;
        }

        table th {
            background-color: #f2f2f2;
            font-weight: bold;
        }

        table tbody td {
            height: 40px;
        }

        tr:nth-child(even) {
            background-color: #D6EEEE;
        }

    </style>
</head>
<body>

<div class="container">
    <h1>Fire alarm system</h1>
    <%
        User user = (User) session.getAttribute("user");
        int user_id = user.getId();
        String name = user.getName();
        deviceDAO deviceDAO = new deviceDAO();
        List<Device> list = deviceDAO.getAllDevices(user_id);
        session.setAttribute("listDevice", list);
    %>
    <div style="font-weight: bold; text-align: left">
        <p >Xin chào, <%=name%></p>
        <a href="index.jsp">Log out</a>
    </div>
    <br/>
    <table>
        <thead>
        <tr>
            <th>STT</th>
            <th>Name</th>
            <th>Location</th>
        </tr>
        </thead>
        <tbody>
        <%
            int index = 0;
            for( Device device : list){
                index++;
        %>
        <tr onclick="window.location.href='manager.jsp?deviceId=<%=device.getId()%>'">
            <td><%=index%></td>
            <td><%=device.getName()%></td>
            <td><%=device.getLocation()%></td>
        </tr>
        <%

            }
        %>

        </tbody>
    </table>
</div>
</body>
</html>
