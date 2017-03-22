
# this container will generate all the go source, then run it

FROM phusion/baseimage:0.9.19

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
ENV PROTOC_RELEASE "protoc-3.1.0-linux-x86_64"

VOLUME /proto
VOLUME /output

COPY . /usr/app
WORKDIR /usr/app

RUN cd /tmp && \
  echo 'deb http://download.opensuse.org/repositories/home:/estan:/protoc-gen-doc/xUbuntu_16.04/ /' > /etc/apt/sources.list.d/protoc-gen-doc.list && \
  curl -sL https://deb.nodesource.com/setup_7.x | sudo -E bash - && \
  apt-get update && \
  apt-get -y --allow-unauthenticated install unzip golang git protoc-gen-doc nodejs build-essential && \
  git clone https://github.com/googleapis/googleapis.git /protobuf && \
  curl -L https://github.com/google/protobuf/releases/download/v3.1.0/${PROTOC_RELEASE}.zip -o protoc.zip && \
  unzip protoc.zip && \
  mv bin/protoc /usr/local/bin && \
  mv include/google/protobuf /protobuf/google/ && \
  go get -u \
    github.com/gengo/grpc-gateway/protoc-gen-grpc-gateway \
    github.com/gengo/grpc-gateway/protoc-gen-swagger \
    github.com/golang/protobuf/protoc-gen-go \
  apt-get remove -y --purge unzip git curl && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  npm install && \
  chmod 755 /usr/app/build_gateway.sh /usr/app/src/protoc-grpc-main

ENTRYPOINT /usr/app/build_gateway.sh

# ENTRYPOINT ["/usr/local/bin/protoc", "-I/protobuf"]
# CMD ["--help"]