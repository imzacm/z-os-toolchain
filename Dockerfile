FROM ubuntu:latest AS base
RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app
ENV DEBIAN_FRONTEND="noninteractive" \
    CARGO_HOME="/usr/src/app/toolchain/prefix/cargo"
RUN apt-get update && apt-get install -y \
    bash curl wget \
    build-essential bison flex libgmp3-dev \
    libmpc-dev libmpfr-dev texinfo libisl-dev
COPY ./setup-toolchain.sh /tmp/setup-toolchain.sh
RUN chmod +x /tmp/setup-toolchain.sh && bash /tmp/setup-toolchain.sh
ENV PREFIX="/usr/src/app/toolchain/prefix" \
    PATH="/usr/src/app/toolchain/prefix/bin:/usr/src/app/toolchain/prefix/cargo/bin"

FROM base AS action
COPY action-entrypoint.sh /usr/src/app/action-entrypoint.sh
RUN chmod +x /usr/src/app/action-entrypoint.sh
ENTRYPOINT [ "/usr/src/app/action-entrypoint.sh" ]
