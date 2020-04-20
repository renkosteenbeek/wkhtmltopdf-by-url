FROM ubuntu:18.04
MAINTAINER Renko Steenbeek <rsteenbeek@gentle-innovations.nl>

RUN apt update
RUN apt upgrade -y

# Prevent question during installations
ENV TZ=Europe/Amsterdam
ENV DEBIAN_FRONTEND=noninteractive
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

# Download and install wkhtmltopdf and dependencies
RUN apt install -y build-essential xorg libssl-dev libxrender-dev wget gdebi xvfb ttf-mscorefonts-installer php composer bash
RUN wget https://github.com/wkhtmltopdf/wkhtmltopdf/releases/download/0.12.5/wkhtmltox_0.12.5-1.bionic_amd64.deb
RUN gdebi --n wkhtmltox_0.12.5-1.bionic_amd64.deb

#for nano working
ENV TERM xterm

# Composer for Snappy
ADD composer.json /composer.json
RUN composer install

# webservice
ADD index.php /index.php
EXPOSE 80

# to make php -S handle sigterm
ENTRYPOINT ["php"]
CMD ["-S", "0.0.0.0:80"]