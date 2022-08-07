#include <ESP8266WiFi.h>
#include <SoftwareSerial.h>
#include <FirebaseArduino.h>
#include <ArduinoJson.h>
#include <ESP8266HTTPClient.h>
#include <DHT.h>

#define FIREBASE_HOST "nodemcu-55328-default-rtdb.firebaseio.com"                          // database URL 
#define FIREBASE_AUTH "E89ghB29OkuptSBQkCHn0pSU9xL3pT4jNcJWl5RO"             // secret key

#define WIFI_SSID "Ruby"
#define WIFI_PASSWORD "24938274_@a!t!m!w!"
#define DHTPIN 2  //be careful the pin no. on the nodeMcu and arduino ide differ 
#define DHTTYPE DHT11 //specifying the type of sensor

DHT dht(DHTPIN, DHTTYPE);

bool light;
bool rgb;
int r, g, b;
unsigned long previousMillis = 0; //for adding a timelimit after which the data will be read
const long interval = 10000;
void setup()
{
  pinMode(14, OUTPUT); //red
  pinMode(12, OUTPUT); //green
  pinMode(13, OUTPUT); //blue


  pinMode(16, OUTPUT);
  pinMode(4, OUTPUT); //for light sensor...............................
  pinMode(5, OUTPUT); //specifying D1 as an output pin
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
  } else     digitalWrite(4, LOW);  //for light sensor...............................


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
    digitalWrite(5, HIGH); //be careful the pin number on nodeMcu and arduino Ide are not the same eg. The used pin 5 in nodemcu is pin D1 not D5.
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
