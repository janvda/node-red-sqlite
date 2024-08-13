FROM nodered/node-red:4.0.2-22

######### Changing to root as below commands should be run as root #############
USER root

# installing sqlite
RUN set -ex && apk --no-cache add sqlite

######### Changing back to node-red user #####################
USER node-red

RUN  cd /data ; npm i --unsafe-perm node-red-node-sqlite
