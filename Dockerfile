FROM nodered/node-red:latest

# Cambiar a root para poder instalar dependencias
USER root

RUN npm install -g node-red-dashboard node-red-node-mqtt node-red-contrib-telegrambot

# Volver al usuario node-red
USER node-red

COPY data/flows.json /data/flows.json

EXPOSE 1880

CMD ["npm", "start", "--", "--userDir", "/data"]
