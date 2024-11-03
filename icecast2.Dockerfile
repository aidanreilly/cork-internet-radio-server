FROM debian:latest as builder

WORKDIR /app

RUN apt-get update \
    && apt-get install --yes icecast2
RUN useradd radio
RUN chown -R radio:radio /etc/icecast2 /var/log/icecast2

USER radio
EXPOSE 8000

ENTRYPOINT [ "icecast2", "-c", "/etc/icecast2/icecast.xml" ]