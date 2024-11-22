<%@ page import="feyd.tengen.fire_alarm.model.Device" %>
<%@ page import="feyd.tengen.fire_alarm.dao.deviceDAO" %>
<%@ page contentType="text/html;charset=UTF-8" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Fire Alarm System</title>
    <script src="https://unpkg.com/mqtt/dist/mqtt.min.js"></script>
    <script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
    <style>

        * {
            margin: 0;
            padding: 0;
            box-sizing: border-box;
        }

        body {
            font-family: Arial, sans-serif;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #ffcccc;
        }

        .container {
            text-align: center;
            padding: 20px;
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            width: 600px;
            height: 337px;
        }
        .data{
            display: grid;
            grid-template-columns: auto auto;
        }
        h1 {
            font-size: 24px;
            margin-bottom: 20px;
        }

        .sensor {
            display: flex;
            flex-direction: column;
            align-items: center;
            margin-bottom: 20px;
        }

        .sensor img {
            width: 60px;
            height: 80px;
        }

        .sensor p {
            font-size: 16px;
            margin: 10px 0;
        }

        .sensor span {
            font-size: 18px;
            font-weight: bold;
        }

        .button-container {
            display: flex;
            align-items:center;
            margin-top: 20px;
            justify-content: center;
        }

        .history {
            background-color: royalblue;
            margin: 5px 10px;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }

        button .history :hover {
            background-color: blue;
        }

        .activate {
            background-color: red;
            margin: 5px 10px;
            color: #fff;
            border: none;
            padding: 10px 20px;
            border-radius: 5px;
            cursor: pointer;
        }

        button .activate :hover {
            background-color: #c9302c;
        }

        #alertBox {
            background-color: gold;
            padding: 10px;
            border: 2px solid red;
            text-align: center;
            margin-top: 10px;
            font-size: 80px;
            position: absolute;
            top: 0;
            height: 100px;
            width: 100%;
        }
    </style>
</head>
<div id="alertBox" style="display: none; color: red; font-weight: bold;"></div>
<body>

<script >
    const client = mqtt.connect('wss://c9a71105d0a84229921d5cf0df2c9b2d.s1.eu.hivemq.cloud:8884/mqtt', {
        username: "hoangduy",
        password: "Duy@12345",
    });

    client.on('connect', () => {
        console.log('Connected to MQTT');
        client.subscribe('esp32/dht11');
        client.subscribe('esp32/buzzer');
    });

    client.on('message', (topic, message) => {
        if (topic === 'esp32/dht11') {
            const data = JSON.parse(message.toString());
            if( data.device_id === document.getElementById('deviceName').innerText){
                document.getElementById('temperature').innerText = data.temperature + ' °C';
                document.getElementById('humidity').innerText = data.humidity + ' %';
            }

        } else if (topic === 'esp32/buzzer') {
            const buzzState = JSON.parse(message.toString());
            console.log(buzzState)
            if(buzzState.device_id === document.getElementById('deviceName').innerText){
                if (buzzState.status === 'fire_detected') {
                    showAlert();  // Hiển thị cảnh báo nếu buzzState là "fire_detected"
                } else {
                    hideAlert();  // Ẩn cảnh báo nếu buzzState khác "normal"
                }
            }

        }
    });

    function sendMessage(topic, deviceId, state) {
        // Tạo payload JSON
        const message = JSON.stringify({
            device_id: deviceId,
            status: state
        });

        // Gửi message
        client.publish(topic, message, { qos: 0, retain: false }, (error) => {
            if (error) {
                console.error("Failed to send message:", error);
            } else {
                console.log("Message sent successfully:", message);
            }
        });
    }


    function showAlert() {

        const deviceId = document.getElementById('deviceID').innerText;
        const temperature = document.getElementById('temperature').innerText;
        const humidity = document.getElementById('humidity').innerText;
        const location = document.getElementById('deviceLocation').innerText;

        const alertBox = document.getElementById("alertBox");
        alertBox.style.display = "block";
        alertBox.innerText = "Có cháyyyyyyyy tại " + location.split(':')[1];

        // Gửi dữ liệu nhiệt độ và độ ẩm lên server khi có báo cháy

        //console.log({ deviceId, temperature, humidity });
        // Gọi AJAX để gửi dữ liệu lên server
        fetch('saveData.jsp', {
            method: 'POST',
            headers: { 'Content-Type': 'application/json' },
            body: JSON.stringify({ deviceId, temperature, humidity })

        })
            .then(response => {
                if (!response.ok) {
                    throw new Error(`HTTP error! status: ${response.status}`);
                }
                return response.json();
            })
            .then(data => console.log(data))
            .catch(error => console.error('Error:', error));
    }

    function hideAlert() {
        const alertBox = document.getElementById("alertBox");
        alertBox.style.display = "none";
    }
</script>
<div class="container">
    <h1>Fire alarm system</h1>
    <%
        int deviceId = Integer.parseInt(request.getParameter("deviceId"));
        deviceDAO deviceDAO = new deviceDAO();
        Device device = deviceDAO.getDeviceById(deviceId);
    %>
    <div style="text-align: left">
        <p hidden id="deviceID"><%=deviceId%></p>
        <p id = "deviceName" style="font-weight: bold"><%=device.getName()%></p>
        <p id="deviceLocation" style="font-weight: bold">Location: <%=device.getLocation()%></p>
    </div>

    <br/>
    <div class="data">
        <div class="sensor">
            <img src="temperature.png" alt="Temperature">
            <p>Nhiệt độ: <span id="temperature">--</span></p>
        </div>
        <div class="sensor" >
            <img style="width: 100px; height: 80px" src="humidity.png" alt="Humidity">
            <p>Độ ẩm: <span id="humidity">--</span></p>
        </div>
    </div>
    <div class="button-container">
        <button class="history" onclick="location.href='listDevice.jsp'">Quay lại</button>
        <button class="history" onclick="location.href='history.jsp?deviceId=<%=deviceId%>'">Lịch sử</button>
        <button class="activate" onclick="sendMessage('esp32/client','<%=device.getName()%>' , '1')" >Kích hoạt</button>
    </div>
</div>

</body>
</html>

