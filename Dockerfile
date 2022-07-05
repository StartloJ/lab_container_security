FROM python:3.10-alpine3.15

LABEL Developer="Start"
LABEL Platform="DevSecOps"

ENV ANCHORE_CLI_URL=http://api:8228/v1
ENV ANCHORE_CLI_USER=admin
ENV ANCHORE_CLI_PASS=foobar

RUN addgroup -g 1000 -S anchore && \
    adduser -D -u 1000 -S anchore -G anchore

USER anchore

RUN pip install --upgrade --user pip anchorecli