FROM nodered/node-red:latest

RUN npm install --save node-red-dashboard node-red-node-mqtt node-red-contrib-telegrambot

COPY data/flows.json /data/flows.json

EXPOSE 1880

CMD ["npm", "start", "--", "--userDir", "/data"]
