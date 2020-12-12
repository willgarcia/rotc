FROM node:15.4.0-alpine

COPY files/ /files/
COPY webui-dist.js /files/webui.js

WORKDIR /files
RUN npm install express redis

CMD ["node", "webui.js"]
EXPOSE 80
