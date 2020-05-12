FROM node:10
RUN npm install express redis swagger-stats
COPY files/ /files/
COPY webui.js /
CMD ["node", "webui.js"]
EXPOSE 80
