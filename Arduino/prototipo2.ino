#include <Wire.h>
#include "MAX30105.h"
#include "heartRate.h"
#include <OneWire.h>
#include <DallasTemperature.h>
#include <WiFi.h>
#include <PubSubClient.h>

// Wifi
const char* ssid = "TP-Link_2C28";
const char* password = "41272480";

// ThingsBoard
const char* mqtt_server = "iot.ceisufro.cl";
const int mqtt_port = 1883;
const char* token = "Izv20eKxVGH8YNcTmQkg";

WiFiClient espClient;
PubSubClient client(espClient);

// Sensor temperatura
const int oneWireBus = 4;
OneWire oneWire(oneWireBus);
DallasTemperature sensors(&oneWire);
unsigned long lastTempRead = 0;
const unsigned long tempInterval = 10000;
float temperatureC = 0;

// Sensor MAX30102
MAX30105 particleSensor;
const byte RATE_SIZE = 4;
byte rates[RATE_SIZE];
byte rateSpot = 0;
long lastBeat = 0;
float beatsPerMinute = 0;
int beatAvg = 0;

//spo2
#define SPO2_BUFFER_SIZE 50
long redBuffer[SPO2_BUFFER_SIZE];
long irBuffer[SPO2_BUFFER_SIZE];
int spo2Index = 0;
float spo2 = 0;

//filtro promedio
#define FILTRO_TAMANO 4
float bpmFiltro[FILTRO_TAMANO] = {0};
float spo2Filtro[FILTRO_TAMANO] = {0};
int filtroIndex = 0;
//mqtt
unsigned long lastMqttSend = 0;
const unsigned long mqttSendInterval = 5000;

float calcularPromedio(float* arreglo, int n) {
  float suma = 0;
  for (int i = 0; i < n; i++) suma += arreglo[i];
  return suma / n;
}

void setup() {
  Serial.begin(115200);
  WiFi.begin(ssid, password);
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("WiFi conectado");

  client.setServer(mqtt_server, mqtt_port);

  sensors.begin();

  Wire.begin(21, 22);
  if (!particleSensor.begin(Wire, I2C_SPEED_FAST)) {
    Serial.println("MAX30102 no encontrado.");
    while (1);
  }

  particleSensor.setup();
  particleSensor.setPulseAmplitudeRed(0x3F);
  particleSensor.setPulseAmplitudeIR(0x3F);
  particleSensor.setPulseAmplitudeGreen(0);

  Serial.println("Coloca tu dedo sobre el sensor.");
}

void reconnect() {
  while (!client.connected()) {
    Serial.print("Conectando a ThingsBoard MQTT...");
    if (client.connect("ESP32", token, NULL)) {
      Serial.println("¡Conectado!");
    } else {
      Serial.print("Fallo con estado ");
      Serial.println(client.state());
      delay(2000);
    }
  }
}

void loop() {
  long irValue = particleSensor.getIR();
  long redValue = particleSensor.getRed();
  bool dedoDetectado = irValue > 50000;

  if (dedoDetectado && checkForBeat(irValue)) {
    long delta = millis() - lastBeat;
    lastBeat = millis();
    beatsPerMinute = 60 / (delta / 1000.0);
    if (beatsPerMinute < 255 && beatsPerMinute > 20) {
      rates[rateSpot++] = (byte)beatsPerMinute;
      rateSpot %= RATE_SIZE;
    }
  }

  if (dedoDetectado) {
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
  } else {
    spo2 = 0;
    beatsPerMinute = 0;
  }

  // Filtrar y suavizar
  bpmFiltro[filtroIndex] = beatsPerMinute;
  spo2Filtro[filtroIndex] = spo2;
  filtroIndex = (filtroIndex + 1) % FILTRO_TAMANO;

  float bpmProm = calcularPromedio(bpmFiltro, FILTRO_TAMANO);
  float spo2Prom = calcularPromedio(spo2Filtro, FILTRO_TAMANO);

  // Validar rangos
  if (bpmProm < 40 || bpmProm > 180) bpmProm = 0;
  if (spo2Prom < 85 || spo2Prom > 100) spo2Prom = 0;

  // Temperatura
  if (millis() - lastTempRead > tempInterval) {
    sensors.requestTemperatures();
    temperatureC = sensors.getTempCByIndex(0);
    lastTempRead = millis();
  }

  // Mostrar resultados
  Serial.print("BPM = ");
  Serial.print(bpmProm);
  Serial.print(" | SpO2 = ");
  Serial.print(spo2Prom);
  Serial.print(" | Temp = ");
  Serial.print(temperatureC);
  if (!dedoDetectado) Serial.print(" (No finger)");
  Serial.println();

  // MQTT
  if (!client.connected()) reconnect();
  client.loop();

  if (millis() - lastMqttSend >= mqttSendInterval) {
    String payload = "{";
    payload += "\"temperature\":" + String(temperatureC, 1) + ",";
    payload += "\"bpm\":" + String(bpmProm, 1) + ",";
    payload += "\"spo2\":" + String(spo2Prom, 1) + ",";
    payload += "\"dedoDetectado\":" + String(dedoDetectado ? "true" : "false");
    payload += "}";

    client.publish("v1/devices/me/telemetry", payload.c_str());
    lastMqttSend = millis();
    Serial.println("Publicando: " + payload);
    Serial.println(client.connected() ? "Conectado" : "NO conectado");
  }
}
