FROM
RUN npm install express
RUN npm install redis
COPY files/ /files/
COPY webui-dist.js /
CMD ["node", "webui.js"]
EXPOSE 80
