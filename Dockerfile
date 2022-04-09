FROM rust:latest as builder
RUN apt-get update && apt-get install pkg-config libssl-dev
WORKDIR /usr/src/mikrus_recycling
COPY . .
RUN cargo install --path .
CMD ["/usr/local/cargo/bin/mikrus_recycling"]
