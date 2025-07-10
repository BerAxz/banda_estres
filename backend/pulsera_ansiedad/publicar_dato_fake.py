import paho.mqtt.client as mqtt
import json

# ⚠️ CAMBIA esto por el token de tu dispositivo real en ThingsBoard
TOKEN = "Izv20eKxVGH8YNcTmQkg"

BROKER = "iot.ceisufro.cl"
PORT = 1883
TOPIC = "v1/devices/me/telemetry"

client = mqtt.Client()
client.username_pw_set(TOKEN)
client.connect(BROKER, PORT, 60)

dato = {
    "bpm": 85,
    "spo2": 98,
    "temperatura": 36.7
}

client.publish(TOPIC, json.dumps(dato))
print("✅ Dato enviado a ThingsBoard")

client.disconnect()
