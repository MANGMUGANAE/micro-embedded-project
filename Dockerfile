FROM ubuntu:22.04 AS build
RUN dpkg --add-architecture arm64 && \
    sed -i 's/^deb /deb [arch=amd64] /' /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports jammy main universe" >> /etc/apt/sources.list && \
    echo "deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports jammy-updates main universe" >> /etc/apt/sources.list && \
    apt-get update && \
    apt-get install -y cmake crossbuild-essential-arm64 libgpiod-dev:arm64
WORKDIR /src
COPY . .
RUN cmake -B build -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=aarch64 -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc -DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++
RUN cmake --build build

FROM scratch
COPY --from=build /src/build/app /app
