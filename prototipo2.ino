#include <Wire.h>
#include "MAX30105.h"
#include "heartRate.h"
#include <OneWire.h>
#include <DallasTemperature.h>
#include <WiFi.h>
#include <PubSubClient.h>

//Wifi
const char* ssid = "WIFI-DCI";
const char* password = "DComInf_2K24";

// thingsboard
const char* mqtt_server = "iot.ceisufro.cl";
const int mqtt_port = 1883;
const char* token = "Izv20eKxVGH8YNcTmQkg";

WiFiClient espClient;
PubSubClient client(espClient);

// DS18B20
const int oneWireBus = 4;
OneWire oneWire(oneWireBus);
DallasTemperature sensors(&oneWire);
unsigned long lastTempRead = 0;
const unsigned long tempInterval = 5000;

// Max30102
MAX30105 particleSensor;

const byte RATE_SIZE = 4;
byte rates[RATE_SIZE];
byte rateSpot = 0;
long lastBeat = 0;

float beatsPerMinute;
int beatAvg;

// SpO2
#define SPO2_BUFFER_SIZE 10
long redBuffer[SPO2_BUFFER_SIZE];
long irBuffer[SPO2_BUFFER_SIZE];
int spo2Index = 0;
float spo2 = 0;

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi conectado");

  client.setServer(mqtt_server, mqtt_port);

  Serial.println("Initializing sensor...");
  // Inicializar sensor temperatura
  sensors.begin();

  // Inicializar el sensor MAX30102
  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) {
    Serial.println("MAX30102 not found. Check wiring.");
    while (1);
  }

  particleSensor.setup();
  particleSensor.setPulseAmplitudeRed(0x1F);
  particleSensor.setPulseAmplitudeIR(0x1F);
  particleSensor.setPulseAmplitudeGreen(0);

  Serial.println("Place your finger on the sensor.");
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Conectando a ThingsBoard MQTT...");
    if (client.connect("ESP32", token, NULL)) {
      Serial.println("Conectao!");
    } else {
      Serial.print("Fallo con estado ");
      Serial.print(client.state());
      delay(2000);
    }
  }
}

void loop() {
  // sensor temperatura
  float temperatureC = 0;
  if (millis() - lastTempRead > tempInterval) {
    sensors.requestTemperatures();
    temperatureC = sensors.getTempCByIndex(0);
    lastTempRead = millis();

    Serial.print(" | Temperature = ");
    Serial.print(temperatureC);
    Serial.print("°C");
  }

  long irValue = particleSensor.getIR();
  long redValue = particleSensor.getRed();

  // Calcular BPM
  if (checkForBeat(irValue) == true) {
    long delta = millis() - lastBeat;
    lastBeat = millis();
    beatsPerMinute = 60 / (delta / 1000.0);
    if (beatsPerMinute < 255 && beatsPerMinute > 20) {
      rates[rateSpot++] = (byte)beatsPerMinute;
      rateSpot %= RATE_SIZE;
    }
  }

  // Calcular SpO2
  redBuffer[spo2Index] = redValue;
  irBuffer[spo2Index] = irValue;
  spo2Index++;

  if (spo2Index >= SPO2_BUFFER_SIZE) {
    long redDC = 0, irDC = 0;
    long redAC = 0, irAC = 0;

    for (int i = 0; i < SPO2_BUFFER_SIZE; i++) {
      redDC += redBuffer[i];
      irDC += irBuffer[i];
    }

    redDC /= SPO2_BUFFER_SIZE;
    irDC /= SPO2_BUFFER_SIZE;

    for (int i = 0; i < SPO2_BUFFER_SIZE; i++) {
      redAC += abs(redBuffer[i] - redDC);
      irAC += abs(irBuffer[i] - irDC);
    }

    float R = ((float)redAC / redDC) / ((float)irAC / irDC + 0.0001);
    spo2 = 110.0 - 25.0 * R;
    if (spo2 > 100) spo2 = 100;
    if (spo2 < 0) spo2 = 0;

    spo2Index = 0;
  }

  // Mostrar resultados en consola
  Serial.print("BPM = ");
  Serial.print(beatsPerMinute);
  Serial.print(" | SpO2 = ");
  Serial.print(spo2, 1);
  Serial.print("%");

  if (irValue < 50000)
    Serial.print(" (No finger detected?)");

  Serial.println();

  if (!client.connected()) {
    reconnect();
  }
  client.loop();

  // Crear mensaje JSON
  String payload = "{";
  payload += "\"temperature\":" + String(temperatureC, 1) + ",";
  payload += "\"bpm\":" + String(beatsPerMinute, 1) + ",";
  payload += "\"spo2\":" + String(spo2, 1);
  payload += "}";

  // Publicar
  client.publish("v1/devices/me/telemetry", payload.c_str());
  
}
