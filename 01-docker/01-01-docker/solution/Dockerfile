FROM node:10.11.0-alpine
RUN npm install express redis
COPY files/ /files/
COPY webui.js /
CMD ["node", "webui.js"]
EXPOSE 80
