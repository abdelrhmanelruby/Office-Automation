#include <Servo.h>
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

Servo servo;
DHT dht(DHTPIN, DHTTYPE);

bool light;
bool rgb;
bool DoorLock;
bool Door;
bool Security;
int DoorState;
int r, g, b;

unsigned long previousMillis = 0;
const long interval = 60000;
void setup()
{
  servo.attach(10); //tx for servomotor servo.write(0);
  //delay(2000);


  pinMode(14, OUTPUT);  //red
  pinMode(12, OUTPUT); //green
  pinMode(13, OUTPUT); //blue
  pinMode(0, OUTPUT); //doorlock
  pinMode(5, INPUT_PULLUP); //doorstate
  pinMode(16, OUTPUT); //alarm for gas
  pinMode(4, OUTPUT); //for light sensor
  pinMode(15, OUTPUT); //light
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
  int h = dht.readHumidity();
  int t = dht.readTemperature();
  int n = analogRead(A0);
  Serial.println(t);
  Serial.println(h);
  Serial.println(n);
  Firebase.setInt("Data/Temperature:", t);
  Firebase.setInt("Data/Humidity:", h);
  Firebase.setInt("Data/Gas detector:", n);
}


void loop()
{
  int n = analogRead(A0);
  if (n > 600)
  {
    digitalWrite(16, HIGH);
  } else if (n < 600 && DoorState == 0) {
    digitalWrite(16, LOW);
  }


  // if (n < 35)
  // {
  //  digitalWrite(4, HIGH);
  // } else  digitalWrite(4, LOW); //for light sensor


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

  DoorLock = Firebase.getBool("DoorLock/switch");
  if (DoorLock == true)
  {
    digitalWrite(0, HIGH);
  } else digitalWrite(0, LOW);


  DoorState = digitalRead(D1);
  Security = Firebase.getBool("Security/switch");
  if (DoorState == 1 && Security == 0)
  {
    digitalWrite(16, HIGH);
  } else if (n < 600 && DoorState == 0) {


    digitalWrite(16, LOW);
  }
  Serial.println(DoorState);

  Door = Firebase.getBool("Door/switch");
  if (Door == 1) {
    servo.write(90);
  } else servo.write(0);





  light = Firebase.getBool("LightState/switch");
  //Serial.println(light);
  if (light == true) {
    digitalWrite(15, HIGH);
  } else digitalWrite(15, LOW);

  unsigned long currentMillis = millis();
  if (currentMillis - previousMillis >= interval) { //to avoid reading the data from DHT sensor every second readDatas();
    previousMillis = currentMillis;
  }
}
