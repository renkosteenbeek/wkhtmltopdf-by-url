# Wkhtmltopdf by url
This Docker service uses Wkhtmltopdf 0.12.5 to generate PDF documents

## Introduction
WKhtmltopdf is a greate PDF generator, using Qt Webkit as rendering engine, providing excellent results.

## Principles
A PDF document will be generated based on the provided URL. The URL can be provided by POST or GET, using the argument 'url'. Hostnames are be filtered using the enviroment variable allowdHosts, so the PDF generator will block access to any other hostname. Use * to allow any hostname.

## Arguments
Any wkhtmltopdf option can be set using environment variables.

Additional arguments:
* title - the returned file name
* footer - the name of the footer to include. The footer must be present in the root of the container

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

## Example usage
http://localhost:8008?url=https%3A%2F%2Fdewereldopjebord.nl%2Fgroente-biryani%2F%2Fprint?title=groente-biryani


