#include <MQ135.h>
#include <ESP8266WiFi.h>
#include <DHT.h>
#include <FirebaseArduino.h>

#define DHTTYPE DHT11 

#define DHTPIN 2

DHT dht(DHTPIN, DHTTYPE); 

#define FIREBASE_HOST "attacheco-79f5f.firebaseio.com"
#define FIREBASE_AUTH "4UFTnZAvECxQ1Hnh48Moh567SZljoPqvCInU1vGq"
#define WIFI_SSID ""
#define WIFI_PASSWORD ""

#define ANALOGPIN A0

int val;

MQ135 gasSensor = MQ135(ANALOGPIN);

void setup() {
// put your setup code here, to run once:
Serial.begin(115200);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("connecting");
  while (WiFi.status() != WL_CONNECTED)
      {
    Serial.print(".");
    delay(500);
      }
  Serial.println();
  Serial.print("connected: ");
  Serial.println(WiFi.localIP());
  
  Firebase.begin(FIREBASE_HOST, FIREBASE_AUTH);
}

void loop() {
val = analogRead(A0); 
//float ppm = gasSensor.getPPM();
float h = dht.readHumidity();   
float t = dht.readTemperature();   
float c = dht.convertCtoF(t);
Firebase.setFloat("Device_1/gas", val); 
Firebase.setFloat("Device_1/temp", c);
Firebase.setFloat("Device_1/hum", h);
}
