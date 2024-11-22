#include "DHTesp.h"
#include <PubSubClient.h>
#include <WiFiClientSecure.h>
#include <ArduinoJson.h>
#include <WiFi.h>

#define FLAME_PIN 35 // Pin kết nối với cảm biến lửa
#define BUZZER_PIN 4 // Pin kết nối với buzzer
#define DHTPIN 15         // Chân GPIO cho Data của DHT
#define DHTTYPE DHT11     // Chọn loại DHT11 hoặc DHT22
#define MQ2_PIN 34 

DHTesp dht;

const char* ssid = "iPhone (110)";   //Wifi connect
const char* password = "88888888";   //Password

const char* mqtt_server = "c9a71105d0a84229921d5cf0df2c9b2d.s1.eu.hivemq.cloud";
const int mqtt_port = 8883;
const char* mqtt_username = "hoangduy"; //User
const char* mqtt_password = "Duy@12345"; //Password

WiFiClientSecure espClient;
PubSubClient client(espClient);
const char* device_id = "DEVICE_001";

void setup_wifi() {
  Serial.print("Connecting to ");
  Serial.println(ssid);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi connected");
  Serial.println("IP address: ");
  Serial.println(WiFi.localIP());
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Attempting MQTT connection...");
    String clientID =  "ESPClient-" + String(random(0xffff), HEX);
    if (client.connect(clientID.c_str(), mqtt_username, mqtt_password)) {
      Serial.println("connected");
      client.subscribe("esp32/client");
    } else {
      Serial.print("failed, rc=");
      Serial.print(client.state());
      Serial.println(" try again in 5 seconds");
      delay(5000);
    }
  }
}

void callback(char* topic, byte* payload, unsigned int length) {
  String incomingMessage = "";
  for (int i = 0; i < length; i++) {
    incomingMessage += (char)payload[i];
  }
  Serial.println("Message arrived [" + String(topic) + "] " + incomingMessage);

  DynamicJsonDocument doc(512);
  DeserializationError error = deserializeJson(doc, incomingMessage);

  if (error) {
    Serial.print("Error parsing JSON: ");
    Serial.println(error.f_str());
    return;
  }

  // Extract fields
  String deviceId = doc["device_id"].as<String>();
  String status = doc["status"].as<String>();

  // Kiểm tra device_id
  if (deviceId == device_id) {
    if (status == "1") {
      Serial.println("Fire detected! Activating buzzer...");
      digitalWrite(BUZZER_PIN, HIGH); // Bật buzzer
      publishMessage("esp32/buzzer", "{\"device_id\":\"" + deviceId + "\",\"status\":\"fire_detected\"}", true);
    } else if (status == "0") {
      Serial.println("Fire reset! Deactivating buzzer...");
      digitalWrite(BUZZER_PIN, LOW); // Tắt buzzer
      publishMessage("esp32/buzzer", "{\"device_id\":\"" + deviceId + "\",\"status\":\"normal\"}", true);
    } else {
      Serial.println("Unknown action: " + status);
    }
  } else {
    Serial.println("Message not for this device. Ignored.");
  }

}

void publishMessage(const char* topic, String payload, boolean retained){
  if(client.publish(topic, payload.c_str(), true))
    Serial.println("Message published ["+String(topic)+"]: "+payload);
}

void setup() {
  pinMode(FLAME_PIN, INPUT);
  pinMode(BUZZER_PIN, OUTPUT);
  pinMode(MQ2_PIN, INPUT);
  Serial.begin(9600);
  dht.setup(DHTPIN, DHTesp::DHT11);
  setup_wifi();
  espClient.setInsecure();
  client.setServer(mqtt_server, mqtt_port);
  client.setCallback(callback);
}

unsigned long timeUpdata=millis();

void loop() {

  if (!client.connected()) {
      reconnect();
  }
    client.loop();

  if (millis() - timeUpdata > 2000) {
    delay(dht.getMinimumSamplingPeriod());
    float h = dht.getHumidity();
    float t = dht.getTemperature();

    DynamicJsonDocument doc(1024);
    doc["device_id"] = device_id;
    doc["humidity"] = h;
    doc["temperature"] = t;
    char mqtt_message[128];
    serializeJson(doc, mqtt_message); 
    publishMessage("esp32/dht11", mqtt_message, true);
  
    int mq2Value = analogRead(MQ2_PIN);  // Đọc giá trị từ MQ-2
    Serial.print("MQ-2 Sensor Value: ");
    Serial.println(mq2Value);
    int flameValue = analogRead(FLAME_PIN); // Đọc giá trị từ cảm biến lửa
    Serial.print("Cảm biến lửa: "); 
    Serial.println(flameValue);// In giá trị cảm biến ra serial monitor
    if (flameValue < 2500 || mq2Value > 2200 ) { // Nếu cảm biến phát hiện có lửa hoặc có khói
      digitalWrite(BUZZER_PIN, HIGH); // Bật buzzer
      DynamicJsonDocument alertDoc(1024);
      alertDoc["device_id"] = device_id;
      alertDoc["status"] = "fire_detected";
      char alert_message[128];
      serializeJson(alertDoc, alert_message);
      publishMessage("esp32/buzzer", alert_message, true);
    } else {
      digitalWrite(BUZZER_PIN, LOW); // Tắt buzzer
      DynamicJsonDocument alertDoc(1024);
      alertDoc["device_id"] = device_id;
      alertDoc["status"] = "normal"; // Trạng thái bình thường
      char alert_message[128];
      serializeJson(alertDoc, alert_message);
      publishMessage("esp32/buzzer", alert_message, true);
    }
    timeUpdata = millis();
  }
  
}


