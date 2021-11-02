FROM ubuntu:latest AS base
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ENV DEBIAN_FRONTEND="noninteractive" \
    CARGO_HOME="/usr/src/app/toolchain/prefix/cargo" \
    PREFIX="/usr/src/app/toolchain/prefix" \
    PATH="${PREFIX}/bin:/usr/src/app/toolchain/prefix/cargo/bin:${PATH}"
RUN apt-get update && apt-get install -y \
    bash curl python3 \
    build-essential bison flex libgmp3-dev \
    libmpc-dev libmpfr-dev texinfo libisl-dev
COPY Makefile config.mk sources.mk ./
RUN make TARGET=i686-elf

FROM base AS action
COPY action-entrypoint.sh /usr/src/app/action-entrypoint.sh
RUN chmod +x /usr/src/app/action-entrypoint.sh
ENTRYPOINT [ "/usr/src/app/action-entrypoint.sh" ]
