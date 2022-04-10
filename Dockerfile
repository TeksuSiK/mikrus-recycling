FROM rust:1.60.0 as builder
RUN apt-get update && apt-get install pkg-config libssl-dev && rm -rf /var/lib/apt/lists/*
WORKDIR /app
ADD . /app
RUN cargo build --release

FROM debian:bullseye-slim as worker
RUN apt-get update && apt-get install ca-certificates -y && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/mikrus_recycling /
CMD ["./mikrus_recycling"]