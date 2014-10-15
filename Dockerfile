FROM ubuntu
MAINTAINER cedric lamoriniere <cedric.lamoriniere@gmail.com>

RUN apt-get update
RUN apt-get install -yq git wget unzip
RUN apt-get install -yq nginx
WORKDIR /tmp
RUN wget http://storage.googleapis.com/dart-archive/channels/stable/release/latest/sdk/dartsdk-linux-x64-release.zip
RUN unzip dartsdk-linux-x64-release.zip
RUN mv dart-sdk /opt
ENV PATH /opt/dart-sdk/bin:$PATH

RUN echo "\ndaemon off;" >> /etc/nginx/nginx.conf


# Install the dart server app.

ADD pubspec.yaml  /container/pubspec.yaml
#ADD pubspec.lock  /container/pubspec.lock
ADD lib           /container/lib
ADD bin           /container/bin
ADD web           /container/web

# Build the app. Do not touch this.
WORKDIR /container
RUN pub build

ADD kubernetes_ui_nginx  /etc/nginx/sites-available/
RUN cd /etc/nginx/sites-enabled/ && ln -s ../sites-available/kubernetes_ui_nginx
RUN rm -f /etc/nginx/sites-enabled/default

RUN ls /container/build/web

EXPOSE 80
EXPOSE 443

CMD nginx
