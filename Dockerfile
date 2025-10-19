FROM nodered/node-red:latest

USER root

# Instalar los nodos globales
RUN npm install -g node-red-dashboard node-red-contrib-telegrambot

# Corregir permisos de la carpeta /data y caché de npm
RUN mkdir -p /data/.npm && chown -R node-red:node-red /data /usr/src/node-red /usr/local/lib/node_modules

USER node-red

COPY data/flows.json /data/flows.json

EXPOSE 1880
CMD ["npm", "start", "--", "--userDir", "/data"]
