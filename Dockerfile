FROM ubuntu:20.04
MAINTAINER Renko Steenbeek <rsteenbeek@gentle-innovations.nl>

# Prevent question during installations
ENV TZ=Europe/Amsterdam
ENV DEBIAN_FRONTEND=noninteractive
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

# Download and install wkhtmltopdf and dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y wget gdebi xvfb ttf-mscorefonts-installer php composer;

# Get Wkhtmltopdf
RUN wget https://downloads.wkhtmltopdf.org/obsolete/linux/wkhtmltopdf-0.11.0_rc1-static-amd64.tar.bz2;
RUN tar -xjf  wkhtmltopdf-0.11.0_rc1-static-amd64.tar.bz2; \
    mv wkhtmltopdf-amd64 /usr/local/bin/wkhtmltopdf; \
    rm -f wkhtmltopdf-0.11.0_rc1-static-amd64.tar.bz2;

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

COPY healthcheck.sh /healthcheck.sh
HEALTHCHECK --interval=10s CMD /healthcheck.sh