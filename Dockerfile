
# this container will generate all the go source, then run it

FROM nodesource/xenial:6.3.1

ENV GOPATH /go
ENV PATH $GOPATH/bin:$PATH
ENV PROTOC_RELEASE "protoc-3.1.0-linux-x86_64"

VOLUME /output

COPY . /usr/app
WORKDIR /usr/app

RUN cd /tmp && \
  apt-get update && \
  apt-get -y install unzip golang && \
  git clone https://github.com/googleapis/googleapis.git /protobuf && \
  curl -L https://github.com/google/protobuf/releases/download/v3.1.0/${PROTOC_RELEASE}.zip -o protoc.zip && \
  unzip protoc.zip && \
  mv bin/protoc /usr/local/bin && \
  mv include/google/protobuf /protobuf/google/ && \
  go get -u \
    github.com/gengo/grpc-gateway/protoc-gen-grpc-gateway \
    github.com/gengo/grpc-gateway/protoc-gen-swagger \
    golang.org/x/net/context \
    google.golang.org/grpc \
    google.golang.org/grpc/codes \
    google.golang.org/grpc/grpclog \
    google.golang.org/grpc/metadata \
    github.com/golang/protobuf/protoc-gen-go && \
  apt-get remove -y --purge unzip git curl && \
  apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
  chmod 755 /usr/app/build_gateway.sh /usr/app/src/protoc-gen-grpc-main

RUN npm install

ENTRYPOINT ["/usr/app/build_gateway.sh"]
