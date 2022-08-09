#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>
#include <FirebaseArduino.h>
#include <ArduinoJson.h>
#include <ESP8266HTTPClient.h>
#include <DHT.h>

#define FIREBASE_HOST "********"                         
#define FIREBASE_AUTH "********"             

#define WIFI_SSID "********"
#define WIFI_PASSWORD "********"
#define DHTPIN 2  
#define DHTTYPE DHT11 

DHT dht(DHTPIN, DHTTYPE);

bool light;
bool rgb;
int r, g, b;
unsigned long previousMillis = 0; 
const long interval = 10000;
void setup()
{
  pinMode(14, OUTPUT); //red
  pinMode(12, OUTPUT); //green
  pinMode(13, OUTPUT); //blue


  pinMode(16, OUTPUT);
  pinMode(4, OUTPUT); 
  pinMode(5, OUTPUT); 
  Serial.begin(115200);
  delay(500);
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
  dht.begin();

  Serial.println("DHT11 Humidity & temperature Sensor\n\n");
  //delay(1000);
}





void readDatas() {
  float h = dht.readHumidity();
  float t = dht.readTemperature();
  int n = analogRead(A0);
  Serial.println(t);
  Serial.println(h);
  Firebase.setFloat("Data/Temperature:", t);
  Firebase.setFloat("Data/Humidity:", h);
  Firebase.setFloat("Data/Gas detector:", n);
}





void loop()
{
  int n = analogRead(A0);
  Serial.println(n);

  if (n > 600)
  {
    digitalWrite(16, HIGH);
  } else     digitalWrite(16, LOW);


  if (n < 25)
  {
    digitalWrite(4, HIGH);
  } else     digitalWrite(4, LOW);  


  rgb = Firebase.getBool("RgbState/switch");
  if (rgb == true) {
    r = Firebase.getInt("rgb/red");
    g = Firebase.getInt("rgb/green");
    b = Firebase.getInt("rgb/blue");
    digitalWrite(14, r);
    digitalWrite(12, g);
    digitalWrite(13, b);
  } else {
    digitalWrite(14, 0);
    digitalWrite(12, 0);
    digitalWrite(13, 0);
  }




  light = Firebase.getBool("LightState/switch");
  //Serial.println(light);
  if (light == true) {
    digitalWrite(5, HIGH); 
  }
  if (light == false) {
    digitalWrite(5, LOW);
  }
  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) { //to avoid reading the data from DHT sensor every second
    readDatas();
    previousMillis = currentMillis;
  }
}
