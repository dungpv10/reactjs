FROM node:7.10

# Create app directory
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

# Install app dependencies
RUN npm install pm2 -g
COPY ./init_scripts/init.sh /
RUN chmod +x /init.sh 
EXPOSE 3000

CMD ["sh", "/init.sh"]


