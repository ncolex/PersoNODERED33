import os
import zipfile

# Crear estructura
os.makedirs("PersoNODERED33/data", exist_ok=True)

# Archivos del proyecto
dockerfile = """FROM nodered/node-red:latest

RUN npm install --save node-red-dashboard node-red-node-mqtt node-red-contrib-telegrambot

COPY data/flows.json /data/flows.json

EXPOSE 1880

CMD ["npm", "start", "--", "--userDir", "/data"]
"""

fly_toml = """app = "personodered33"
primary_region = "scl"

[build]
  image = "nodered/node-red:latest"

[[services]]
  internal_port = 1880
  processes = ["app"]
  protocol = "tcp"

  [[services.ports]]
    handlers = ["http"]
    port = 80

  [[services.ports]]
    handlers = ["tls", "http"]
    port = 443

  [[services.tcp_checks]]
    interval = "15s"
    timeout = "2s"
"""

flows_json = """[
  {
    "id": "flow1",
    "type": "tab",
    "label": "Main Flow",
    "disabled": false
  },
  {
    "id": "mqtt_in",
    "type": "mqtt in",
    "z": "flow1",
    "name": "Sensor MQTT",
    "topic": "sensores/temperatura",
    "qos": "2",
    "datatype": "auto",
    "broker": "mqtt_local",
    "x": 150,
    "y": 120,
    "wires": [["ui_gauge"]]
  },
  {
    "id": "ui_gauge",
    "type": "ui_gauge",
    "z": "flow1",
    "name": "Temperatura",
    "group": "grupo_dashboard",
    "order": 1,
    "width": "6",
    "height": "3",
    "gtype": "gage",
    "title": "Temperatura °C",
    "label": "°C",
    "format": "{{value}}",
    "min": 0,
    "max": 50,
    "colors": ["#00b500", "#e6e600", "#ca3838"],
    "x": 420,
    "y": 120,
    "wires": []
  },
  {
    "id": "telegram_in",
    "type": "telegram receiver",
    "z": "flow1",
    "name": "Bot Telegram",
    "bot": "telegram_bot",
    "x": 160,
    "y": 240,
    "wires": [["telegram_function"], []]
  },
  {
    "id": "telegram_function",
    "type": "function",
    "z": "flow1",
    "name": "Responder comando",
    "func": "if (msg.payload.content === '/temp') {\\n msg.payload = { chatId: msg.payload.chatId, type: 'message', content: 'Temperatura actual: 25°C' };\\n} else {\\n msg.payload = { chatId: msg.payload.chatId, type: 'message', content: 'Comando no reconocido.' };\\n}\\nreturn msg;",
    "outputs": 1,
    "x": 420,
    "y": 240,
    "wires": [["telegram_sender"]]
  },
  {
    "id": "telegram_sender",
    "type": "telegram sender",
    "z": "flow1",
    "name": "Enviar respuesta",
    "bot": "telegram_bot",
    "x": 680,
    "y": 240,
    "wires": []
  },
  {
    "id": "mqtt_local",
    "type": "mqtt-broker",
    "name": "Broker local",
    "broker": "test.mosquitto.org",
    "port": "1883",
    "clientid": "personodered33-client",
    "usetls": false,
    "keepalive": "60",
    "cleansession": true
  },
  {
    "id": "telegram_bot",
    "type": "telegram bot",
    "botname": "PersoBot33",
    "pollinterval": "300",
    "usesocks": false,
    "token": "PONE_TU_TOKEN_AQUI"
  },
  {
    "id": "grupo_dashboard",
    "type": "ui_group",
    "name": "Monitoreo",
    "tab": "tab_dashboard",
    "order": 1,
    "disp": true,
    "width": "6",
    "collapse": false
  },
  {
    "id": "tab_dashboard",
    "type": "ui_tab",
    "name": "Panel IoT",
    "icon": "dashboard",
    "order": 1
  }
]"""

# Escribir los archivos
with open("PersoNODERED33/Dockerfile", "w") as f:
    f.write(dockerfile)

with open("PersoNODERED33/fly.toml", "w") as f:
    f.write(fly_toml)

with open("PersoNODERED33/data/flows.json", "w") as f:
    f.write(flows_json)

# Crear ZIP
zip_path = "/mnt/data/PersoNODERED33.zip"
with zipfile.ZipFile(zip_path, "w", zipfile.ZIP_DEFLATED) as zipf:
    for root, dirs, files in os.walk("PersoNODERED33"):
        for file in files:
            file_path = os.path.join(root, file)
            arcname = os.path.relpath(file_path, "PersoNODERED33")
            zipf.write(file_path, arcname)

zip_path
