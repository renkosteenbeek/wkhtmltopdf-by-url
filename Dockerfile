ARG ARCH=
FROM ${ARCH}ubuntu:20.04
MAINTAINER Renko Steenbeek <rsteenbeek@gentle-innovations.nl>

# Prevent question during installations
ENV TZ=Europe/Amsterdam
ENV DEBIAN_FRONTEND=noninteractive
RUN echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

# Download and install wkhtmltopdf and dependencies
RUN apt-get update && apt-get upgrade -y && apt-get install -y wget gdebi xvfb ttf-mscorefonts-installer php composer

# Get Wkhtmltopdf
RUN if [ "$ENV" = "arm" ] ; then \
        wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_arm64.deb && \
        gdebi --n wkhtmltox_0.12.6-1.focal_arm64.deb; \
    else \
        wget https://github.com/wkhtmltopdf/packaging/releases/download/0.12.6-1/wkhtmltox_0.12.6-1.focal_amd64.deb && \
        gdebi --n wkhtmltox_0.12.6-1.focal_amd64.deb; \
    fi

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