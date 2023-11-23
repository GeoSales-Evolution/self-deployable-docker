FROM docker:latest
RUN apk add bash
COPY ./hestia /app/hestia
COPY ./.env /app/.env
COPY ./private_registry_login.sh /app/private_registry_login.sh
RUN ./app/private_registry_login.sh
WORKDIR /app
ENTRYPOINT ["/app/hestia"]
