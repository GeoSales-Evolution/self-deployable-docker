FROM docker:latest
RUN apk add bash
COPY ./hestia /app/hestia
WORKDIR /app
ENTRYPOINT ["/app/hestia"]
