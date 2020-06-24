FROM ubuntu:20.04
MAINTAINER Renko Steenbeek <rsteenbeek@gentle-innovations.nl>

# Prevent question during installations
ENV TZ=Europe/Amsterdam
ENV DEBIAN_FRONTEND=noninteractive
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

# Download and install wkhtmltopdf and dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y build-essential xorg libssl-dev libxrender-dev wget gdebi xvfb ttf-mscorefonts-installer php composer bash;

# Get Wkhtmltopdf
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.4/wkhtmltox-0.12.4_linux-generic-amd64.tar.xz;
RUN tar xf wkhtmltox-0.12.4_linux-generic-amd64.tar.xz; \
    cd wkhtmltox; \
    mv bin/* /usr/local/bin; \
    mv include/* /usr/local/inlcude; \
    mv lib/* /usr/local/lib; \
    mv share/* /usr/local/share;

#for nano working
ENV TERM xterm

# Composer for Snappy
ADD composer.json /composer.json
RUN composer install

# Allow all hosts by default
ENV allowedHosts=*

# webservice
ADD index.php /index.php
ADD templates.json /templates.json
ADD entrypoint.sh /entrypoint.sh
EXPOSE 80

ENTRYPOINT ["/entrypoint.sh"]