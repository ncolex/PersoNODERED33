FROM nodered/node-red:latest

USER root

# Instalar solo los nodos adicionales válidos
RUN npm install -g node-red-dashboard node-red-contrib-telegrambot

USER node-red

COPY data/flows.json /data/flows.json

EXPOSE 1880

CMD ["npm", "start", "--", "--userDir", "/data"]
