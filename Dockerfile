FROM ubuntu:24.04 AS build
RUN dpkg --add-architecture arm64 && \
    sed -i '/^Types: deb$/a Architectures: amd64' /etc/apt/sources.list.d/ubuntu.sources && \
    printf 'deb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports noble main universe\ndeb [arch=arm64] http://ports.ubuntu.com/ubuntu-ports noble-updates main universe\n' > /etc/apt/sources.list.d/arm64.list && \
    apt-get update && \
    apt-get install -y cmake crossbuild-essential-arm64 git autoconf automake libtool pkg-config

RUN git clone https://github.com/brgl/libgpiod.git /tmp/libgpiod && \
    cd /tmp/libgpiod && \
    git checkout $(git tag --sort=-v:refname | head -1) && \
    autoreconf -vfi && \
    ./configure --host=aarch64-linux-gnu --prefix=/opt/arm64 --disable-shared --enable-static --disable-tools --disable-bindings-cxx && \
    make -j$(nproc) && \
    make install

WORKDIR /src
COPY . .
RUN cmake -B build -DCMAKE_SYSTEM_NAME=Linux -DCMAKE_SYSTEM_PROCESSOR=aarch64 \
    -DCMAKE_C_COMPILER=aarch64-linux-gnu-gcc -DCMAKE_CXX_COMPILER=aarch64-linux-gnu-g++ \
    -DCMAKE_C_FLAGS=-I/opt/arm64/include -DCMAKE_CXX_FLAGS=-I/opt/arm64/include \
    -DCMAKE_EXE_LINKER_FLAGS=-L/opt/arm64/lib
RUN cmake --build build

FROM scratch
COPY --from=build /src/build/app /app
