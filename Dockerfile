FROM ubuntu:16.04
RUN apt-get -y update && apt-get -y upgrade && apt-get install -y bash wget libmicrohttpd-dev libjansson-dev libnice-dev \
                                         libopus-dev libssl-dev libsofia-sip-ua-dev libglib2.0-dev \
                                         libogg-dev pkg-config gengetopt libtool automake git cmake

RUN cd ~ && \
    wget https://github.com/cisco/libsrtp/archive/v2.0.0.tar.gz && \
    tar xfv v2.0.0.tar.gz && \
    cd libsrtp-2.0.0 && \
    ./configure --prefix=/usr --enable-openssl && \
    make shared_library && make install && \
    cd ~ && rm -rf libsrtp-1.5.4

RUN git clone https://github.com/sctplab/usrsctp && \
    cd usrsctp && \
    ./bootstrap && \
    ./configure --prefix=/usr && make && make install && \
    cd ~ && rm -rf usrsctp

RUN git clone https://github.com/warmcat/libwebsockets.git && \
    cd libwebsockets && \
    git checkout v1.5-chrome47-firefox41 && \
    mkdir build && \
    cd build && \
    cmake -DCMAKE_INSTALL_PREFIX:PATH=/usr -DCMAKE_C_FLAGS="-fpic" .. && \
    make && make install && \
    cd ~ && rm -rf libwebsockets

RUN git clone https://github.com/meetecho/janus-gateway.git && \
    cd janus-gateway && \
    sh autogen.sh && \
    ./configure --prefix=/opt/janus --disable-rabbitmq --disable-mqtt && \
    make && \
    make install && make configs && \
    rm /opt/janus/etc/janus/*.cfg.sample && \
    mkdir -p /opt/janus/certs && \
    openssl req -x509 -sha256 -nodes -days 365 -newkey rsa:1024 -keyout /opt/janus/certs/privateKey.key -out /opt/janus/certs/certificate.crt -subj '/C=US/ST=California/L=Palo Alto/O=Mattermost/OU=WebRTC/CN=dockerhost' && \
    cd ~ && rm -rf janus-gateway

COPY vagrant/janus/config/*.cfg /opt/janus/etc/janus/

EXPOSE 7088
EXPOSE 7089
EXPOSE 8188
EXPOSE 8189

CMD /opt/janus/bin/janus