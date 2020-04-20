# Wkhtmltopdf by url
This Docker service uses Wkhtmltopdf 0.12.5 to generate PDF documents

## Introduction
WKhtmltopdf is a greate PDF generator, using Qt Webkit as rendering engine, providing great results.

## Principles
A PDF document will be generated based on the provided URL. The URL can be provided by POST or GET.
Hostname should be filtered using the enviroment variable allowdHosts

## Docker-compose example
```version: "3.2"
services:
  pdf:
    image: renkosteenbeek/wkhtmltopdf-by-url:1.0
    environment:
      page-size: "A4"
      margin-top: 15
      margin-left: 13
      margin-right: 13
      margin-bottom: 20
      zoom: 1.5
      defaultTitle: 'Report'
      defaultFooter: 'footer_default.html'
      allowedHosts: dewereldopjebord.nl, www.dewereldopjebord.nl
    volumes:
      - ./footer_default.html:/footer_default.html
    ports:
      - "8008:80"
```
Exampe URL
http://localhost:8008?url=dewereldopjebord.nl/recipe=1