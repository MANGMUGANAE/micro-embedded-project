FROM ubuntu:24.04 AS build
RUN dpkg --add-architecture arm64 && \
    sed -i '/^Types: deb$/a Architectures: amd64' /etc/apt/sources.list.d/ubuntu.sources && \
    printf 'deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports noble main universe\ndeb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports noble-updates main universe\n' > /etc/apt/sources.list.d/arm64.list && \
    apt-get update && \
    apt-get install -y cmake crossbuild-essential-arm64 libgpiod-dev:arm64
WORKDIR /src
COPY . .
RUN cmake -B build -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=aarch64 -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc -DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++
RUN cmake --build build

FROM scratch
COPY --from=build /src/build/app /app
