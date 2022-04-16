FROM rust:1.60.0 as builder
RUN apt-get update && apt-get install pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*
WORKDIR /app
ADD . /app
RUN cargo build --release

FROM debian:bullseye-slim as worker
RUN apt-get update && apt-get install cron ca-certificates -y && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/mikrus_recycling /
COPY cronjob /etc/cron.d/mikrus
COPY entrypoint.sh /entrypoint.sh
RUN chmod 0644 /etc/cron.d/mikrus
RUN crontab /etc/cron.d/mikrus
RUN touch /var/log/cron.log
ENTRYPOINT [ "sh", "/entrypoint.sh" ]